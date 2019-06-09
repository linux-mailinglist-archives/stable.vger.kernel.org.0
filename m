Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06EAD3A6BE
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfFIQLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:11:04 -0400
Received: from mail180-16.suw31.mandrillapp.com ([198.2.180.16]:28481 "EHLO
        mail180-16.suw31.mandrillapp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728635AbfFIQLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jun 2019 12:11:04 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Jun 2019 12:11:03 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=mandrill; d=nexedi.com;
 h=From:Subject:To:Cc:Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding; i=kirr@nexedi.com;
 bh=UBm1Ha65NyTbaemRU67DRfuweZgj6OScpzVWtCG9DoQ=;
 b=cSudXZmYERnrrrzI9G9woQP0/Hr0Ao0pxGJwUibbcEgG6Wym30aJOcRV5XbLzurRCNww5L3ZLiV4
   7dSrCtYopBidQvIbSGOUquf1tjpJAXKPogHWp/EkraiqJ0ZTlwUOfvBidahkBkj48WvCmiQ+IynZ
   jYK5mRatci6LXfLLclQ=
Received: from pmta03.mandrill.prod.suw01.rsglab.com (127.0.0.1) by mail180-16.suw31.mandrillapp.com id hvknpe22sc0a for <stable@vger.kernel.org>; Sun, 9 Jun 2019 15:41:08 +0000 (envelope-from <bounce-md_31050260.5cfd2894.v1-8fce3c44c7374c67b8012120a13d08d9@mandrillapp.com>)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com; 
 i=@mandrillapp.com; q=dns/txt; s=mandrill; t=1560094868; h=From : 
 Subject : To : Cc : Message-Id : Date : MIME-Version : Content-Type : 
 Content-Transfer-Encoding : From : Subject : Date : X-Mandrill-User : 
 List-Unsubscribe; bh=UBm1Ha65NyTbaemRU67DRfuweZgj6OScpzVWtCG9DoQ=; 
 b=HCGWYl/Rckhjez9wDIRgb5cUIzQ/IH4fMLPHgH6fPYX2GakJ5Fm/xaGM4vpa9RAxgrZDa7
 t4LV2X39uym+09rhg//jrxwJIJ6lHRJL8eWf+awBjst17raOT7vq3BImyqGn2yit7hU0NrRn
 W1tJwNuFYIJMCSfc0MHRaRsk/hjE8=
From:   Kirill Smelkov <kirr@nexedi.com>
Subject: [PATCH 3.16 0/2] Fix FUSE read/write deadlock on stream-like files
Received: from [87.98.221.171] by mandrillapp.com id 8fce3c44c7374c67b8012120a13d08d9; Sun, 09 Jun 2019 15:41:08 +0000
X-Mailer: git-send-email 2.20.1
To:     <stable@vger.kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kirill Smelkov <kirr@nexedi.com>
Message-Id: <20190609135607.9840-1-kirr@nexedi.com>
X-Report-Abuse: Please forward a copy of this message, including all headers, to abuse@mandrill.com
X-Report-Abuse: You can also report abuse here: http://mandrillapp.com/contact/abuse?id=31050260.8fce3c44c7374c67b8012120a13d08d9
X-Mandrill-User: md_31050260
Date:   Sun, 09 Jun 2019 15:41:08 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello stable team,

Please consider applying the following 2 patches to Linux-3.16 stable
tree. The patches fix regression introduced in 3.14 where both read and
write started to run under lock taken, which resulted in FUSE (and many
other drivers) deadlocks for cases where stream-like files are used with
read and write being run simultaneously.

Please see complete problem description in upstream commit 10dce8af3422
("fs: stream_open - opener for stream-like files so that read and write
can run simultaneously without deadlock").

The actual FUSE fix (upstream commit bbd84f33652f "fuse: Add
FOPEN_STREAM to use stream_open()") was merged into 5.2 with `Cc:
stable@vger.kernel.org # v3.14+` mark and is already included into 5.1,
5.0 and 4.19 stable trees. However for some reason it is not (yet ?)
included into 4.14, 4.9, 4.4, 3.18 and 3.16 trees.

The patches fix a real problem into which my FUSE filesystem ran, and
which also likely affects OSSPD (full details are in the patches
description). Please consider including the fixes into 3.16 (as well as
into other stable trees - I'm sending corresponding series separately -
- one per tree).

Thanks beforehand,
Kirill

P.S. the patches have been already a bit discussed in stable context some
time ago:

https://lore.kernel.org/linux-fsdevel/CAHk-=wgh234SyBG810=vB360PCzVkAhQRqGg8aFdATZd+daCFw@mail.gmail.com/
https://lore.kernel.org/linux-fsdevel/20190424183012.GB3798@deco.navytux.spb.ru/
https://lore.kernel.org/linux-fsdevel/20190424191652.GE3798@deco.navytux.spb.ru/
...

Kirill Smelkov (2):
  fs: stream_open - opener for stream-like files so that read and write can run simultaneously without deadlock
  fuse: Add FOPEN_STREAM to use stream_open()

 drivers/xen/xenbus/xenbus_dev_frontend.c |   2 +-
 fs/fuse/file.c                           |   4 +-
 fs/open.c                                |  18 ++
 fs/read_write.c                          |   5 +-
 include/linux/fs.h                       |   4 +
 include/uapi/linux/fuse.h                |   2 +
 scripts/coccinelle/api/stream_open.cocci | 363 +++++++++++++++++++++++
 7 files changed, 394 insertions(+), 4 deletions(-)
 create mode 100644 scripts/coccinelle/api/stream_open.cocci

-- 
2.20.1
