Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583622A1C20
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 06:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725773AbgKAFiQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 01:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgKAFiO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 01:38:14 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C8CC0617A6;
        Sat, 31 Oct 2020 22:38:14 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f38so8185174pgm.2;
        Sat, 31 Oct 2020 22:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h0UPMaHl9sQ1QYtD72P2Gtya64wSdEwNqN6m40oRNsA=;
        b=WhG+3QfgIcd8FEd+xMfq2+PFDMbU3yKbbZSIlonfA1ApWGA4gU1bW0orKx/iLuiuD1
         Z+kjTIvH09Gw9KTvvDBtEec3691SQzjLUZBGw/M87/jtqzjNrPdDEfygAnZqXqa+v8Fm
         L7pfJ7kdI04aA4mKAmUbHrzVV86KOwkiAlsUM6WlcfNYb5IRDkdaLEJjiiOcLbwQMT2C
         DLiMRmRu9mGbcexKK2oVWj8TCW3xfQPpDQpKqu0niH8PeGQLJV/jz2M9KyX7rx6jSk7d
         K1cCNXqPI4WtOBwKxTBf5wFldIH2LoDdnC7I2C7CC7thtXwRrIXcPiBFAmC9+lxcXOht
         uUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h0UPMaHl9sQ1QYtD72P2Gtya64wSdEwNqN6m40oRNsA=;
        b=hlrW1K9Kd0aj2LUPyywIp54wQJQLCEIqy6NC0LOEQK231TSTDEiOFMiZXhqSUbcidL
         F79g8RyQ1Yj/icH5XnY1VYEAJvRPr3t+5PeAKwKjw8Oo2sObpYM3rEr+VcmyEmUQbcqe
         /nCt6YlxQEDiDGvlzUiHEUQgkoom8hEW0nzkBR1nrLR1k4rCRoC8cMbXwGiE9H2hqMF8
         TQbWMFCwZjLziDq72UrF9ya/LCcNAJxRyNAetG3ieMRe0W0XR6wafXoX7uAUHLO1vbqe
         5xp/2AmnIISEpMhKmGK0/56K47x665lMzL90wbHNujkEUHzwnBMxsa6zDiCnllx1TKhB
         2rrA==
X-Gm-Message-State: AOAM530SYuvy5RxSuv6Yvsp8gItvjC0IRHOnJ/qPSrErsYTfPeFZ6akk
        8nAMVL413/Z5wN3FBrsf08w=
X-Google-Smtp-Source: ABdhPJz8JY5kc/jUUwoCuti7DG3VKLSeM35nguxL7NxmueK5tY+OX9jYzu40IOaFEDMs65Fuk77CtQ==
X-Received: by 2002:a62:aa0f:0:b029:162:ecc2:4d44 with SMTP id e15-20020a62aa0f0000b0290162ecc24d44mr16564428pff.52.1604209093832;
        Sat, 31 Oct 2020 22:38:13 -0700 (PDT)
Received: from clanlab.dyndns.org ([140.119.175.157])
        by smtp.gmail.com with ESMTPSA id e5sm8486972pjd.0.2020.10.31.22.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 22:38:13 -0700 (PDT)
From:   Macpaul Lin <macpaul@gmail.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mediatek WSD Upstream <wsd_upstream@mediatek.com>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Cc:     Eddie Hung <eddie.hung@mediatek.com>,
        Peter Chen <peter.chen@nxp.com>, stable@vger.kernel.org
Subject: [RESEND PATCH v2] usb: gadget: configfs: Fix use-after-free issue with udc_name
Date:   Sun,  1 Nov 2020 13:37:28 +0800
Message-Id: <20201101053728.2387434-1-macpaul@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
References: <1595040303-23046-1-git-send-email-macpaul.lin@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eddie Hung <eddie.hung@mediatek.com>

There is a use-after-free issue, if access udc_name
in function gadget_dev_desc_UDC_store after another context
free udc_name in function unregister_gadget.

Context 1:
gadget_dev_desc_UDC_store()->unregister_gadget()->
free udc_name->set udc_name to NULL

Context 2:
gadget_dev_desc_UDC_show()-> access udc_name

Call trace:
dump_backtrace+0x0/0x340
show_stack+0x14/0x1c
dump_stack+0xe4/0x134
print_address_description+0x78/0x478
__kasan_report+0x270/0x2ec
kasan_report+0x10/0x18
__asan_report_load1_noabort+0x18/0x20
string+0xf4/0x138
vsnprintf+0x428/0x14d0
sprintf+0xe4/0x12c
gadget_dev_desc_UDC_show+0x54/0x64
configfs_read_file+0x210/0x3a0
__vfs_read+0xf0/0x49c
vfs_read+0x130/0x2b4
SyS_read+0x114/0x208
el0_svc_naked+0x34/0x38

Add mutex_lock to protect this kind of scenario.

Signed-off-by: Eddie Hung <eddie.hung@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Cc: stable@vger.kernel.org
---
Changes for v2:
  - Fix typo %s/contex/context, Thanks Peter.

 drivers/usb/gadget/configfs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index cbff3b02840d..8501b27f3c95 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -230,9 +230,16 @@ static ssize_t gadget_dev_desc_bcdUSB_store(struct config_item *item,
 
 static ssize_t gadget_dev_desc_UDC_show(struct config_item *item, char *page)
 {
-	char *udc_name = to_gadget_info(item)->composite.gadget_driver.udc_name;
+	struct gadget_info *gi = to_gadget_info(item);
+	char *udc_name;
+	int ret;
+
+	mutex_lock(&gi->lock);
+	udc_name = gi->composite.gadget_driver.udc_name;
+	ret = sprintf(page, "%s\n", udc_name ?: "");
+	mutex_unlock(&gi->lock);
 
-	return sprintf(page, "%s\n", udc_name ?: "");
+	return ret;
 }
 
 static int unregister_gadget(struct gadget_info *gi)
-- 
2.26.2

