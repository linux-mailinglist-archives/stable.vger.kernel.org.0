Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9922E3291DD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhCAUe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:34:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242256AbhCAU1d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:27:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7634765418;
        Mon,  1 Mar 2021 18:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622033;
        bh=KcIk4Kz2b8MBawrOW9nBScge22W/NWosoaZ++Q388m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0D13jiPezL+FQL/yzTmxKy54Tnfmb8DUj2SiJ/t+1BNEEFMlyn7OZPLsRjrIlyQFI
         htSwfkZdKCpXwuFfP2mSGjR5zCDyoqVi8pj6+8Mn8w1EAQmetJc8hGjb+6gxbnof6P
         f6kiesl0WYSslzN95BF3N6KSfDCQEtsbaFD4ZrEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.11 725/775] zonefs: Fix file size of zones in full condition
Date:   Mon,  1 Mar 2021 17:14:53 +0100
Message-Id: <20210301161237.166005493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 059c01039c0185dbee7ed080f1f2bd22cb1e4dab upstream.

Per ZBC/ZAC/ZNS specifications, write pointers may not have valid values
when zones are in full condition. However, when zonefs mounts a zoned
block device, zonefs refers write pointers to set file size even when
the zones are in full condition. This results in wrong file size. To fix
this, refer maximum file size in place of write pointers for zones in
full condition.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: <stable@vger.kernel.org> # 5.6+
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -250,6 +250,9 @@ static loff_t zonefs_check_zone_conditio
 		}
 		inode->i_mode &= ~0222;
 		return i_size_read(inode);
+	case BLK_ZONE_COND_FULL:
+		/* The write pointer of full zones is invalid. */
+		return zi->i_max_size;
 	default:
 		if (zi->i_ztype == ZONEFS_ZTYPE_CNV)
 			return zi->i_max_size;


