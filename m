Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B7D676D2F
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjAVNpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjAVNpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:45:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E55D93F0;
        Sun, 22 Jan 2023 05:45:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7914B80AD2;
        Sun, 22 Jan 2023 13:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506F8C433D2;
        Sun, 22 Jan 2023 13:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674395142;
        bh=6qUeEO1YYbP5ZALYKGC/qa5S706OPhIYpJ2pP62OYnc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h8giy6lNYlwItTTqiXQmpHdRbaJa8yVzDnZvsdSQGCwFP9nU2T1pa1LA6utuEIBIR
         EQzAR8WdJAspkCnesvmlJlp8JjWIUdwBdCT0bzVufG9g770WCQ3esCdXjvbth452oV
         XONlk2qrjeccdZbywrK7v5eVzHH9bCcvPyd50o+k=
Date:   Sun, 22 Jan 2023 14:45:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     =?iso-8859-1?Q?J=2E_Pablo_Gonz=E1lez?= <disablez@disablez.com>,
        linux-cifs@vger.kernel.org, stable@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [Bug report] Since 5.17 kernel, non existing files may be
 treated as remote DFS entries
Message-ID: <Y80+BM6J1nfEu1XO@kroah.com>
References: <CAF2j4JFp2=J41j3d7MU-QNmHWPbfidG9V86gGagzEm-e4sDRQQ@mail.gmail.com>
 <878ri2d446.fsf@cjr.nz>
 <CAF2j4JG_w4XD=LzhPHWAMjA2yRqJ6A4K+x8XZ36d2zJOuZp4KQ@mail.gmail.com>
 <87pmbbwjr1.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmbbwjr1.fsf@cjr.nz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 18, 2023 at 07:38:58PM -0300, Paulo Alcantara wrote:
> Stable team,
> 
> J. Pablo González <disablez@disablez.com> writes:
> 
> > On Mon, Jan 16, 2023 at 2:02 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >>
> >> J. Pablo González <disablez@disablez.com> writes:
> >>
> >> > We’re experiencing some issues when accessing some mounts in a DFS
> >> > share, which seem to happen since kernel 5.17.
> >> >
> >> > After some investigation, we’ve pinpointed the origin to commit
> >> > a2809d0e16963fdf3984409e47f145
> >> > cccb0c6821
> >> > - Original BZ for that is https://bugzilla.kernel.org/show_bug.cgi?id=215440
> >> > - Patch discussion is at
> >> > https://patchwork.kernel.org/project/cifs-client/patch/YeHUxJ9zTVNrKveF@himera.home/
> >> > - Similar issues referenced in https://bugzilla.suse.com/show_bug.cgi?id=1198753
> >>
> >> 6.2-rc4 has
> >>
> >>         c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
> >>
> >> which should fix your issue.
> >>
> >> Could you try it?  Thanks.
> >
> > I'll still need to test it more thoroughly, but for now, this patch
> > seems to have fixed all issues, including the "-o nodfs ones." Thank
> > you!
> > Any chance this could be formally backported to 6.1.x ? I see it's
> > only tagged for 6.2-rc for now.
> 
> Could you please queue
> 
>         c877ce47e137 ("cifs: reduce roundtrips on create/qinfo requests")
> 
> for 6.1.y as a fix for
> 
>         a2809d0e1696 ("cifs: quirk for STATUS_OBJECT_NAME_INVALID returned for non-ASCII dfs refs")
> 
> Find attached a backportable version of such commit.  Thanks.


Now queued up, thanks.

greg k-h
