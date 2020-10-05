Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE83283B58
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgJEPlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbgJEP25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 492C220637;
        Mon,  5 Oct 2020 15:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911736;
        bh=Fs+Lnk6+k8Me4JBcQtiaRFUGznEJPUpoXfKzT/K0XGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2CMRZhjKq2y8hAVcbxu05fMoU/PG6TpGRUeeXakMBy6UVdBn4Avd4TvR9Xd6jltjo
         cNVTHHlK58+MzQ30C9LXXPuEJ6xmp2PKpRWLGzgme1/6U8z0unvN60cRsilvmwQlr+
         udf03bKt5zQP7z70m4u7YvdviNGxfyXSjtHEHgTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Andr=C3=A9s=20Barrantes=20Silman?= 
        <andresbs2000@protonmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 11/57] Input: i8042 - add nopnp quirk for Acer Aspire 5 A515
Date:   Mon,  5 Oct 2020 17:26:23 +0200
Message-Id: <20201005142110.356861099@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

commit 5fc27b098dafb8e30794a9db0705074c7d766179 upstream.

Touchpad on this laptop is not detected properly during boot, as PNP
enumerates (wrongly) AUX port as disabled on this machine.

Fix that by adding this board (with admittedly quite funny DMI
identifiers) to nopnp quirk list.

Reported-by: Andrés Barrantes Silman <andresbs2000@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Link: https://lore.kernel.org/r/nycvar.YFH.7.76.2009252337340.3336@cbobk.fhfr.pm
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -721,6 +721,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_BOARD_VENDOR, "MICRO-STAR INTERNATIONAL CO., LTD"),
 		},
 	},
+	{
+		/* Acer Aspire 5 A515 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "Grumpy_PK"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "PK"),
+		},
+	},
 	{ }
 };
 


