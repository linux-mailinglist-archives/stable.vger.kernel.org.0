Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3491461616
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 20:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfGGSnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 14:43:17 -0400
Received: from mail180-22.suw31.mandrillapp.com ([198.2.180.22]:44907 "EHLO
        mail180-22.suw31.mandrillapp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726418AbfGGSnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 14:43:16 -0400
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Jul 2019 14:43:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mandrill; d=nexedi.com;
 h=From:Subject:To:Cc:Message-Id:References:In-Reply-To:Date:MIME-Version:Content-Type:Content-Transfer-Encoding; i=kirr@nexedi.com;
 bh=owTjbI7UdD8VgA6b1BMAffbWT0iESkUoHZSCvU4Uh8I=;
 b=bFVa8DZSq7eUa+ec2dXzdRxVhLourcYkZxoJ79tXH3iisWmQ/aw9rM0d5oBBFeSHnN+l5VudB3bK
   oL+PVFRBbZg7IPdlrbpWeIKWHrOBf365b0/sVcSe2DM8blwuNO09Vr3hHF0tOHkWu7X+7tS7YhWX
   VY7deDj1JODPdP4O7FA=
Received: from pmta03.mandrill.prod.suw01.rsglab.com (127.0.0.1) by mail180-22.suw31.mandrillapp.com id h48uk622sc01 for <stable@vger.kernel.org>; Sun, 7 Jul 2019 18:13:12 +0000 (envelope-from <bounce-md_31050260.5d223638.v1-85941fa003c94de7a46b9f2a28de003f@mandrillapp.com>)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com; 
 i=@mandrillapp.com; q=dns/txt; s=mandrill; t=1562523192; h=From : 
 Subject : To : Cc : Message-Id : References : In-Reply-To : Date : 
 MIME-Version : Content-Type : Content-Transfer-Encoding : From : 
 Subject : Date : X-Mandrill-User : List-Unsubscribe; 
 bh=owTjbI7UdD8VgA6b1BMAffbWT0iESkUoHZSCvU4Uh8I=; 
 b=n6bkfqSyFpcjpSmZtlvP5MO+oB6QBTZc52QvHYJQQTLu2lRswkTFoOTTQWI0Kd0a8RSMec
 +ye96X9GnshkMS9xq4ftvBhXmtF1kdeWeHukErR6eeLcR7CO/hDkdYdKMmBI0wx2oF4xwqGG
 XLbL5gerpOBz878QyG68KYvY2Y7sE=
From:   Kirill Smelkov <kirr@nexedi.com>
Subject: Re: [PATCH 3.16 0/2] Fix FUSE read/write deadlock on stream-like files
Received: from [87.98.221.171] by mandrillapp.com id 85941fa003c94de7a46b9f2a28de003f; Sun, 07 Jul 2019 18:13:12 +0000
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <20190707181305.GA25031@deco.navytux.spb.ru>
References: <20190609135607.9840-1-kirr@nexedi.com> <ef1625b5c6921289e2f87cdbb0101ff6301b2a7d.camel@decadent.org.uk>
In-Reply-To: <ef1625b5c6921289e2f87cdbb0101ff6301b2a7d.camel@decadent.org.uk>
X-Report-Abuse: Please forward a copy of this message, including all headers, to abuse@mandrill.com
X-Report-Abuse: You can also report abuse here: http://mandrillapp.com/contact/abuse?id=31050260.85941fa003c94de7a46b9f2a28de003f
X-Mandrill-User: md_31050260
Date:   Sun, 07 Jul 2019 18:13:12 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 07, 2019 at 03:03:45PM +0100, Ben Hutchings wrote:
> On Sun, 2019-06-09 at 15:41 +0000, Kirill Smelkov wrote:
> > Hello stable team,
> > 
> > Please consider applying the following 2 patches to Linux-3.16 stable
> > tree. The patches fix regression introduced in 3.14 where both read and
> > write started to run under lock taken, which resulted in FUSE (and many
> > other drivers) deadlocks for cases where stream-like files are used with
> > read and write being run simultaneously.
> > 
> > Please see complete problem description in upstream commit 10dce8af3422
> > ("fs: stream_open - opener for stream-like files so that read and write
> > can run simultaneously without deadlock").
> > 
> > The actual FUSE fix (upstream commit bbd84f33652f "fuse: Add
> > FOPEN_STREAM to use stream_open()") was merged into 5.2 with `Cc:
> > stable@vger.kernel.org # v3.14+` mark and is already included into 5.1,
> > 5.0 and 4.19 stable trees. However for some reason it is not (yet ?)
> > included into 4.14, 4.9, 4.4, 3.18 and 3.16 trees.
> > 
> > The patches fix a real problem into which my FUSE filesystem ran, and
> > which also likely affects OSSPD (full details are in the patches
> > description). Please consider including the fixes into 3.16 (as well as
> > into other stable trees - I'm sending corresponding series separately -
> > - one per tree).
> [...]
> 
> I've queued these up for 3.16, thanks.

Thanks a lot.

Kirill
