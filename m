Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3169C8C8
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 11:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbjBTKkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 05:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbjBTKkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 05:40:18 -0500
Received: from comms.puri.sm (comms.puri.sm [159.203.221.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4019E423B;
        Mon, 20 Feb 2023 02:39:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 7CBF6EBC82;
        Mon, 20 Feb 2023 02:39:19 -0800 (PST)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lLpB0Md-q2VS; Mon, 20 Feb 2023 02:39:18 -0800 (PST)
Message-ID: <79c96fd4ba3bc2501059a239421feb550357fdd9.camel@puri.sm>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=puri.sm; s=comms;
        t=1676889558; bh=DppJVlcFvXsawCX2N5tcMmHxJghL9KLQuMyF2UnxEAk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RmhebyvxVseKaCxHNbZXn6pT1xADUMCeO1s9H0KEXB4WeacUf1x0e84A5eAGyB165
         oOgw+nP7A6lWLXi8hoWK5kFv0TAAX8lQo56ii13VXiMQaTctsDweHs/9tlIXDgPaQs
         UJPDB0sNG29hzgMmpVBfzyLX70NJFtcytyivXjW7nn9gn4+PMUaDFCjCt5Nw9B9vaX
         W46AFR4GOpE9fSnb16kkMeuUAlFKtMyEEvIYmdIopKf/NEc3ujyH6GNYbzJjCihbZa
         /N0G69B7rP+1GrW2Qr7VCym0n8npk+tGjKIs25hzowF8ry6Pd2q9x2S3xf41lYdOYz
         DOb+uavj/y4/g==
Subject: Re: [PATCH] usb: typec: altmodes/displayport: Fix probe pin assign
 check
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
To:     Prashant Malani <pmalani@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        bleung@chromium.org, stable@vger.kernel.org,
        Diana Zigterman <dzigterman@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Ranquet <granquet@baylibre.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>,
        Pablo Sun <pablo.sun@mediatek.com>
Date:   Mon, 20 Feb 2023 11:39:12 +0100
In-Reply-To: <CACeCKacT2eMC_JzObCji9ZToq4oPqVcdc2CeDiS=DJdj3QdR5w@mail.gmail.com>
References: <20230208205318.131385-1-pmalani@chromium.org>
         <44487e67c4101db4b57090a1ece66974aeab28b9.camel@puri.sm>
         <CACeCKacT2eMC_JzObCji9ZToq4oPqVcdc2CeDiS=DJdj3QdR5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1+deb11u1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Freitag, dem 17.02.2023 um 09:31 -0800 schrieb Prashant Malani:
> On Fri, Feb 17, 2023 at 3:39 AM Martin Kepplinger
> <martin.kepplinger@puri.sm> wrote:
> > 
> > Am Mittwoch, dem 08.02.2023 um 20:53 +0000 schrieb Prashant Malani:
> > > While checking Pin Assignments of the port and partner during
> > > probe,
> > > we
> > > don't take into account whether the peripheral is a plug or
> > > receptacle.
> > > 
> > > This manifests itself in a mode entry failure on certain docks
> > > and
> > > dongles with captive cables. For instance, the Startech.com Type-
> > > C to
> > > DP
> > > dongle (Model #CDP2DP) advertises its DP VDO as 0x405. This would
> > > fail
> > > the Pin Assignment compatibility check, despite it supporting
> > > Pin Assignment C as a UFP.
> > > 
> > > Update the check to use the correct DP Pin Assign macros that
> > > take the peripheral's receptacle bit into account.
> > > 
> > > Fixes: c1e5c2f0cb8a ("usb: typec: altmodes/displayport: correct
> > > pin
> > > assignment for UFP receptacles")
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Diana Zigterman <dzigterman@chromium.org>
> > > Signed-off-by: Prashant Malani <pmalani@chromium.org>
> > > ---
> > > 
> > > I realize this is a bit late in the release cycle, but figured
> > > since
> > > it
> > > is a fix it might still be considered. Please let me know if it's
> > > too
> > > late and I can re-send this after the 6.3-rc1 is released.
> > > Thanks!
> > 
> > 
> > on the imx8mq-librem5r4.dts board, when using a typec-hub with
> > HDMI,
> > this patch breaks image output in one case for me: For a monitor
> > where
> > negotiation of resolution fails, a lower resolution works though, I
> > now
> > get an oops and hence an unusable system, see the
> > dmesg_typec_hub_hdmi_new.txt logs I append. this should definitely
> > not
> > happen.
> 
> I'll let others comment here too, but more information is required
> here:
> - What's the DP VDO being exported by the Hub?
> - What DPConfigure VDM is being sent now (and what was being sent
> earlier) ?
> - Which version of the kernel are you using?
> - Can you point to where in the upstream kernel this board file is
> present?
> 
> > 
> > with your patch reverted, I get no oops and a perfectly usable
> > system
> > like before, which is the file dmesg_typec_hub_hdmi_old_ok.txt
> > 
> > could this patch be wrong or at least no universally good for
> > everyone?
> > it looks like a regression to me.
> 
> I don't think this patch is the cause of the regression you are
> seeing.
> 
> I don't know about the 2nd part, but for the first part, it was
> definitely not right
> earlier; Pin compatibility checks need to take into account whether
> the
> UFP is a receptacle or not. The stack trace you have shared does not
> seem related to PD/Type-C or DRM.
> 
> Perhaps this change is uncovering a previously hidden bug on this
> board.
> I'm not sure how this patch causes the failure you see; the patch
> alters
> the conditions for a probe to succeed: either the HUB you are using
> will
> pass this check (in which case you will get DP working) or it won't
> (in which
> case DP should not work at all). Whatever happens after that depends
> on the display driver.
> 
> BR,


thanks for the quick reply. I think you are right, my report was wrong
and your patch was not the cause of the bug. I was able to reproduce it
without hdmi plugged in. Also, the issue is fixed again in v6.2.

thank you very much and sorry for the false alarm,

                              martin

