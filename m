Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6921883AB7
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 22:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbfHFU6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 16:58:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33042 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfHFU6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 16:58:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so42167202pfq.0;
        Tue, 06 Aug 2019 13:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZTsNG6Bio/AJmAU1Zseq92KqEsNF01Owji7Z6+SXkE=;
        b=rJ1SVqI1FflYb5laPGdRcP3i+hrhR5WqAqQQlGDWeDfIW1kuI+5CaAaHCcG9wPTiJT
         VAhndfrQGid6aczd3WheOk1Z6v14i45wVa5ifP9O3FEXpEpPxePWvoOCjc2KD7eQXgeq
         bi0p91ymuhhu7sF2bg0fP4fiMEoTkYts/HoCQVx2wE0jqvB6WOAcVKGIuwplW59E9Iej
         sf/Y4S+gfQLEpHweC7mITJoQ+qK3aRHyi3dr+hswvTG7hzujaWubtWZlhlkc4ibPnVxc
         DEltCWQJtOsbQsDxLq5i5epD85aRr8HnHZQqyl6NQAZbKkwBhIiVQtpsWRwDT8AQ/W2t
         EGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hZTsNG6Bio/AJmAU1Zseq92KqEsNF01Owji7Z6+SXkE=;
        b=K3w4Kazqz64RHsJiMU56D+i9pC7k6o1LaP2zjlezPBYZASjpjkD80x4kLECtiBPd/x
         XMnBAtoYtETa9pdhjAoVEr3AwFYLLnRKRCjQjVDjdinTdgnTLz16JIL8Gic2v5xvkUlc
         lfBeSLtVqK70ZIyMU+mEYbpwmmo5As9739Es2eAu0aRHmg1wROxx29Euf5T1SQwNRW9T
         K0UFaD2OKEsaV7DtIbeVEJR1AFcLIMCiAsgjl25nDo93M4LG6TVeIho6UVaIZKs+p99F
         lZ9MldOhTZ72f0NJqKI4i9rV45HTW0f6mVzEVi2mkQUUDsNVTewMmIeOHtEHd69a5ZCg
         euPg==
X-Gm-Message-State: APjAAAVxa9vRKpCWWUKe7/ZP/Qlay043HrwbpCNW/E5VPe8jNHPk1vOn
        njDZVKtJk381Y/8A0oZI1z3yLioK
X-Google-Smtp-Source: APXvYqwKGkllarMcKeQEJDUp1fVEiqSjn+ylBqyFpTwYYj6aEelr8VJ6IuPkTLCxLaQmUdVN3NvIQQ==
X-Received: by 2002:aa7:91cc:: with SMTP id z12mr5697539pfa.76.1565125091639;
        Tue, 06 Aug 2019 13:58:11 -0700 (PDT)
Received: from US-191-ENG0002.corp.onewacom.com ([50.225.60.4])
        by smtp.gmail.com with ESMTPSA id k8sm83005126pgm.14.2019.08.06.13.58.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 13:58:10 -0700 (PDT)
From:   "Gerecke, Jason" <killertofu@gmail.com>
X-Google-Original-From: "Gerecke, Jason" <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: [PATCH] HID: wacom: Correct distance scale for 2nd-gen Intuos devices
Date:   Tue,  6 Aug 2019 13:58:05 -0700
Message-Id: <20190806205805.21168-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <jason.gerecke@wacom.com>

Distance values reported by 2nd-gen Intuos tablets are on an inveted scale
(0 == far, 63 == near). We need to change them over to a normal scale before
reporting to userspace or else userspace drivers and applications can get
confused.

Ref: https://github.com/linuxwacom/input-wacom/issues/98
Fixes: eda01dab53 ("HID: wacom: Add four new Intuos devices")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Cc: <stable@vger.kernel.org> # v4.4+
---
 drivers/hid/wacom_wac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 7a8ddc999a8e..879e41fbf604 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -846,6 +846,9 @@ static int wacom_intuos_general(struct wacom_wac *wacom)
 		y >>= 1;
 		distance >>= 1;
 	}
+	if (features->type == INTUOSHT2) {
+		distance = features->distance_max - distance;
+	}
 	input_report_abs(input, ABS_X, x);
 	input_report_abs(input, ABS_Y, y);
 	input_report_abs(input, ABS_DISTANCE, distance);
-- 
2.22.0

