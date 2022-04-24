Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B917450D5DF
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 00:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbiDXXB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Apr 2022 19:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbiDXXB6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Apr 2022 19:01:58 -0400
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com [IPv6:2001:4b98:dc2:55:216:3eff:fef7:d647])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4EC62A0A;
        Sun, 24 Apr 2022 15:58:55 -0700 (PDT)
Received: from pendragon.ideasonboard.com (62-78-145-57.bb.dnainternet.fi [62.78.145.57])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 1420C822;
        Mon, 25 Apr 2022 00:58:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1650841133;
        bh=OxWe0iWDKlDp8IlBYHKkZ/JxNlQhxReU1GVBOdxPQFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nOHXz+99CHZ8PNaRjyq32HlyKTg11IJ+T8pHih1HRaU9oKYH8WqEjF9emBhEPgTiZ
         Zw1LRdei+KAmhQ2IHGul2Qz7+pe/giraberMWqrAPFred20b5zwl8p7v1WZnAX6Tet
         96VnKuipkUKycaJVPSrvCtSIkIor++CoLIEivywE=
Date:   Mon, 25 Apr 2022 01:58:52 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Dan Vacura <w36195@motorola.com>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] usb: gadget: uvc: Fix crash when encoding data for
 usb request
Message-ID: <YmXWLFfN4KTFp0wW@pendragon.ideasonboard.com>
References: <20220331184024.23918-1-w36195@motorola.com>
 <Yl8frWT5VYRdt5zA@pendragon.ideasonboard.com>
 <YmB6v8AbzdOgITT8@p1g3>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YmB6v8AbzdOgITT8@p1g3>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

On Wed, Apr 20, 2022 at 04:27:27PM -0500, Dan Vacura wrote:
> On Tue, Apr 19, 2022 at 11:46:37PM +0300, Laurent Pinchart wrote:
> > 
> > This indeed fixes an issue, so I think we can merge the patch, but I
> > also believe we need further improvements on top (of course if you would
> > like to improve the implementation in a v4, I won't complain :-))
> 
> It looks like Greg has already accepted the change and it's in
> linux-next. We can discuss here how to better handle these -EXDEV errors
> for future improvements, as it seems like it's been an issue in the past
> as well:
> https://www.mail-archive.com/linux-usb@vger.kernel.org/msg105615.html
> 
> > As replied in v2 (sorry for the late reply), it seems that this error
> > can occur under normal conditions. This means we shouldn't cancel the
> > queue, at least when the error is intermitent (if all URBs fail that's
> > another story).
> 
> My impression was that canceling the queue was still necessary as we may
> be in progress for the current frame. Perhaps we don't need to flush all
> the frames from the queue, but at a minimum we need to reset the
> buf_used value.

I think we have three classes of errors:

- "Packet-level" errors, resulting in either data loss or erroneous data
  being transferred to the host for one (or more) packets in a frame.
  When such errors occur, we should probably notify the application (on
  the gadget side), but we can continue sending the rest of the frame.

- "Frame-level" errors, resulting in errors in the rest of the frame.
  When such an error occurs, we should notify the application, and stop
  sending data for the current frame, moving to the next frame.

- "Stream-level" errors, resulting in errors in all subsequent frames.
  When such an error occurs, we should notify the application and stop
  sending data until the application takes corrective measures.

I'm not sure if packet-level errors make sense, if data is lost, maybe
we would be better off just cancelling the current frame and moving to
the next one.

For both packet-level errors and frame-level errors, the buffer should
be marked as erroneous to notify the application, but there should be no
need to cancel the queue and drop all queued buffers. We can just move
to the next buffer.

For stream-level errors, I would cancel the queue, and additionally
prevent new buffers from being queued until the application stops and
restarts the stream.

Finally, which class an error belongs to may not be an intrinsic
property of the error itself, packet-level or frame-level errors that
occur too often may be worth cancelling the queue (I'm not sure how to
quantify "too often" though).

Does this make sense ?

> > We likely need to differentiate between -EXDEV and other errors in
> > uvc_video_complete(), as I'd like to be conservative and cancel the
> > queue for unknown errors. We also need to improve the queue cancellation
> > implementation so that userspace gets an error when queuing further
> > buffers.
> 
> We already feedback to userspace the error, via the state of
> vb2_buffer_done(). When userspace dequeues the buffer it can check if
> v4l2_buffer.flags has V4L2_BUF_FLAG_ERROR to see if things failed, then
> decide what to do like re-queue that frame. However, this appears to not
> always occur since I believe the pump thread is independent of the
> uvc_video_complete() callback. As a result, the complete callback of the
> failed URB may be associated with a buffer that was already released
> back to the userspace client.

Good point. That would only be the case for errors in the last
request(s) for a frame, right ?

> In this case, I don't know if there's
> anything to be done, since a new buffer and subsequent URBs might
> already be queued up. You suggested an error on a subsequent buffer
> queue, but I don't know how helpful that'd be at this point, perhaps in
> the scenario that all URBs are failing?

Should we delay sending the buffer back to userspace until all the
requests for the buffer have completed ?

-- 
Regards,

Laurent Pinchart
