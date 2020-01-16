Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A88C13FD19
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbgAPXV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731984AbgAPXVz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12C9220684;
        Thu, 16 Jan 2020 23:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216915;
        bh=+NWel1XDc0nVhEjZEKuLMD5HJ5Mm8G7/Xz0caA0IHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8RbaMF/gWoCFzeG8PCVZDF+yK36JqfzfLzMwpzwsiWzQXHHnYTwvV0/mBNWaUVL/
         0zm4QGagiD+V8/a42X3MYfgpzDD+egJEH4YXsV7f9I5Ilf7LXr6MN5hz3/Ehmtu5u2
         tXFL8wnU2OZNJqd1IVMmh38mfBus91Q+hauvJOF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Baluta <daniel.baluta@nxp.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 056/203] ASoC: simple_card_utils.h: Add missing include
Date:   Fri, 17 Jan 2020 00:16:13 +0100
Message-Id: <20200116231748.878130122@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Baluta <daniel.baluta@nxp.com>

commit 4bbee14d8e5487e3d2662138e3767cf4678cdf57 upstream.

When debug is enabled compiler cannot find the definition of
clk_get_rate resulting in the following error:

./include/sound/simple_card_utils.h:168:40: note: previous implicit
declaration of ‘clk_get_rate’ was here
   dev_dbg(dev, "%s clk %luHz\n", name, clk_get_rate(dai->clk));
./include/sound/simple_card_utils.h:168:3: note: in expansion of macro
‘dev_dbg’
   dev_dbg(dev, "%s clk %luHz\n", name, clk_get_rate(dai->clk));

Fix this by including the appropriate header.

Fixes: 0580dde59438686d ("ASoC: simple-card-utils: add asoc_simple_debug_info()")
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20191009153615.32105-2-daniel.baluta@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/simple_card_utils.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/sound/simple_card_utils.h
+++ b/include/sound/simple_card_utils.h
@@ -8,6 +8,7 @@
 #ifndef __SIMPLE_CARD_UTILS_H
 #define __SIMPLE_CARD_UTILS_H
 
+#include <linux/clk.h>
 #include <sound/soc.h>
 
 #define asoc_simple_init_hp(card, sjack, prefix) \


