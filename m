Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3873A11B473
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732958AbfLKPrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733080AbfLKP0L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:11 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A4F222C4;
        Wed, 11 Dec 2019 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077970;
        bh=MtFn0xzkL4jTgKuMDJEhK74IZuC3f1IDzLRwoiosD5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G/Vopgy8HI9kgub2Pk0AOOUKjg/ohn4bX2KkSqmBzfjPDg2vBiN8ZuHoatjYdkBsO
         XJz6+/MIlAxychEuKeUQGBRa2RB4/j4Hnf6Eoj4pMyMEeebDLjZ1UrLGVOaDVlFB0G
         sw1UdHB0u/6LzegkK+Fr0ZLu0FmFiyLMnRER8gX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        Jiri Slaby <jslaby@suse.com>
Subject: [PATCH 4.19 241/243] vcs: prevent write access to vcsu devices
Date:   Wed, 11 Dec 2019 16:06:43 +0100
Message-Id: <20191211150355.607717902@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Pitre <nico@fluxnic.net>

commit 0c9acb1af77a3cb8707e43f45b72c95266903cee upstream.

Commit d21b0be246bf ("vt: introduce unicode mode for /dev/vcs") guarded
against using devices containing attributes as this is not yet
implemented. It however failed to guard against writes to any devices
as this is also unimplemented.

Reported-by: Or Cohen <orcohen@paloaltonetworks.com>
Signed-off-by: Nicolas Pitre <npitre@baylibre.com>
Cc: <stable@vger.kernel.org> # v4.19+
Cc: Jiri Slaby <jslaby@suse.com>
Fixes: d21b0be246bf ("vt: introduce unicode mode for /dev/vcs")
Link: https://lore.kernel.org/r/nycvar.YSQ.7.76.1911051030580.30289@knanqh.ubzr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vc_screen.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -437,6 +437,9 @@ vcs_write(struct file *file, const char
 	size_t ret;
 	char *con_buf;
 
+	if (use_unicode(inode))
+		return -EOPNOTSUPP;
+
 	con_buf = (char *) __get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;


