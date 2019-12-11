Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185FA11B5DB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfLKP4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:56:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730487AbfLKPPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:15:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BD122465C;
        Wed, 11 Dec 2019 15:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077323;
        bh=MMmOfzQAQPd+qex/oNeLOW3iayXwmQcSaN9IFAFG1IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoSz32+oRPqhXmmvDwxjlwxRAZchD+WAoTUQGkCBYL5Fr1QI47KM+iM+IZ36t4dG5
         l8rY+LxTAFsozugaRWThiZpnBrl+nCceVguhQ63Fd0O/9J+cbtn2SXH70R+ks6nhPI
         vUZ7O4Yf4hhnE0X6eSW50/6UXTd9QAjDhEqX5qvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Or Cohen <orcohen@paloaltonetworks.com>,
        Nicolas Pitre <npitre@baylibre.com>,
        Jiri Slaby <jslaby@suse.com>
Subject: [PATCH 5.3 102/105] vcs: prevent write access to vcsu devices
Date:   Wed, 11 Dec 2019 16:06:31 +0100
Message-Id: <20191211150304.160317023@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
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


