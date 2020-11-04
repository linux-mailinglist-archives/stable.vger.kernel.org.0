Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F22A6A3C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 17:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731220AbgKDQsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 11:48:53 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:40711 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgKDQsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 11:48:53 -0500
Received: by mail-lf1-f68.google.com with SMTP id e27so5157750lfn.7;
        Wed, 04 Nov 2020 08:48:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=re+vkNaV2IqjWLvWTPODjB+TaAeDQ2wT/vcW13BpaME=;
        b=hZgf1e/JBLQ+7uV5maGFzSLIT+XSMPvNazHtC+O1xqTEk/IQmvbsz3rKJP2JaxYffU
         EVrvigq7sHxZCvEBnJayW7UGHlr0IVoBGo3tLkMCZntgOZtPrDOZzY4OeD4RVQU2H12b
         kHwpiXiBvzDgvl6eQIIUzHLLQASteX29wXy1iYsHuFPYIhmytFLizfnwllTUS27AyNX2
         b+QiQhXRV8poTZMKhmqElW/JCbN6hKtNZvBPzALUfNQAeSd25sKbOqAoJK+8/gp+KMcB
         UbbrwVSdsip2f438bDuKGB2VRPfrtrpqzwTcAIbl4NKPb1B1tqM7u/Pri15EGT6tuLko
         9IzA==
X-Gm-Message-State: AOAM533I9AJaTecfZjJWXkSZm1fCvA+6nXQsdWiR+7G6supFZo9xWGst
        ocSe7SknoTqCKpNkZTmb/g05MC7yMOnYcA==
X-Google-Smtp-Source: ABdhPJyFhRIgQ3n36N/ci6UZOj02hZ7KVRNUZCAsNwUfwnbWw2KB5ijNn73AuDv5Kvhn7VnHmrRucw==
X-Received: by 2002:a19:c80a:: with SMTP id y10mr10860686lff.329.1604508530318;
        Wed, 04 Nov 2020 08:48:50 -0800 (PST)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id x4sm563021ljj.62.2020.11.04.08.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 08:48:49 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kaLxu-0006sC-BR; Wed, 04 Nov 2020 17:48:54 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: serial: mos7720: fix parallel-port state restore
Date:   Wed,  4 Nov 2020 17:47:27 +0100
Message-Id: <20201104164727.26351-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The parallel-port restore operations is called when a driver claims the
port and is supposed to restore the provided state (e.g. saved when
releasing the port).

Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7720.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 5eed1078fac8..5a5d2a95070e 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -639,6 +639,8 @@ static void parport_mos7715_restore_state(struct parport *pp,
 		spin_unlock(&release_lock);
 		return;
 	}
+	mos_parport->shadowDCR = s->u.pc.ctr;
+	mos_parport->shadowECR = s->u.pc.ecr;
 	write_parport_reg_nonblock(mos_parport, MOS7720_DCR,
 				   mos_parport->shadowDCR);
 	write_parport_reg_nonblock(mos_parport, MOS7720_ECR,
-- 
2.26.2

