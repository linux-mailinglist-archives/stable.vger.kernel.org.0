Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6810A11B7EF
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfLKPKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:10:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730796AbfLKPKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:10:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A11A220663;
        Wed, 11 Dec 2019 15:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077043;
        bh=MMmOfzQAQPd+qex/oNeLOW3iayXwmQcSaN9IFAFG1IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UR3ndxP9XQ52VO2kRRTgooi1s/zsxvKU3V1zQ2UuTnT/s57s9pGQ2XitaJReo/6Z8
         lUublPrE/sH0zGjEXbK8UAl3l8de20PO8lVFRe0BD7CO1L0QT5aCAr2jELDZrVJhgl
         efG+csh7wTw2ZI0ptL76Or0PwiAQkUWYYAMoIZ54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        Jiri Slaby <jslaby@suse.com>
Subject: [PATCH 5.4 88/92] vcs: prevent write access to vcsu devices
Date:   Wed, 11 Dec 2019 16:06:19 +0100
Message-Id: <20191211150302.235189670@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
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
@@ -456,6 +456,9 @@ vcs_write(struct file *file, const char
 	size_t ret;
 	char *con_buf;
 
+	if (use_unicode(inode))
+		return -EOPNOTSUPP;
+
 	con_buf = (char *) __get_free_page(GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;


