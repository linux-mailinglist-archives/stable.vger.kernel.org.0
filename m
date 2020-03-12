Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F129182E82
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 12:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgCLLCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 07:02:31 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42440 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbgCLLCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 07:02:31 -0400
Received: by mail-lf1-f67.google.com with SMTP id t21so4417166lfe.9;
        Thu, 12 Mar 2020 04:02:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0gf9nMkz8jNTUgSUmsyUitRVxnbwlxPriCRXIfta74=;
        b=uaH4KGyWOQyUa3Nrgn8X1im+XAZrE62uT73jDB/BJn9L0cUGqrqMsSIyp1y4flNfnD
         RP9GWoBsXpv8eqKBVKoViy7N7mELWlG3vVX7OMQo3LB4IGnmN7QHPuQCAHksh0sotNT+
         0yjNs/9czEQf8pRrh4KchKNoZIb7EotmYkVnVeyZhaTlsVrExIL/WyXTFaUqyeUygjaY
         OF4cwhNRR3VJSjtmHKcEUvgOr7iljJXQ9osJZc9Y3dIRHAXuaIA8VRCY3N81qDLdHQgL
         5oKUXpLDIdWdWrTGT1ebtxC8g0ePFMf96Tuj6GMJZ96t09Sf2bhmQuqjCVREFN35la8o
         Z4MQ==
X-Gm-Message-State: ANhLgQ2TzXLvoU0pbMji8pLpyZQN3hwgh3cLcdCH/XFEGmhUZrGSXRc4
        yfkUarVfLVqhdczlHwhkMDM=
X-Google-Smtp-Source: ADFU+vvQ1bXXJ25BFPPSH7DGiFmSZv25BlmnfXv7XwYE3ZUPwjwP4v9+8zv/blCyHOLkYopDXnMfTg==
X-Received: by 2002:a19:ae03:: with SMTP id f3mr5158733lfc.28.1584010947720;
        Thu, 12 Mar 2020 04:02:27 -0700 (PDT)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id n7sm6309933lfi.5.2020.03.12.04.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 04:02:26 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1jCLbS-0005kH-GI; Thu, 12 Mar 2020 12:02:14 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>,
        Axel Haslam <ahaslam@baylibre.com>,
        Bryan ODonoghue <pure.logic@nexus-software.ie>,
        greybus-dev@lists.linaro.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] staging: greybus: loopback_test: fix poll-mask build breakage
Date:   Thu, 12 Mar 2020 12:01:49 +0100
Message-Id: <20200312110151.22028-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312110151.22028-1-johan@kernel.org>
References: <20200312110151.22028-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A scripted conversion from userland POLL* to kernel EPOLL* constants
mistakingly replaced the poll flags in the loopback_test tool, which
therefore no longer builds.

Fixes: a9a08845e9ac ("vfs: do bulk POLL* -> EPOLL* replacement")
Cc: stable <stable@vger.kernel.org>     # 4.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/staging/greybus/tools/loopback_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/tools/loopback_test.c b/drivers/staging/greybus/tools/loopback_test.c
index ba6f905f26fa..41e1820d9ac9 100644
--- a/drivers/staging/greybus/tools/loopback_test.c
+++ b/drivers/staging/greybus/tools/loopback_test.c
@@ -655,7 +655,7 @@ static int open_poll_files(struct loopback_test *t)
 			goto err;
 		}
 		read(t->fds[fds_idx].fd, &dummy, 1);
-		t->fds[fds_idx].events = EPOLLERR|EPOLLPRI;
+		t->fds[fds_idx].events = POLLERR | POLLPRI;
 		t->fds[fds_idx].revents = 0;
 		fds_idx++;
 	}
@@ -748,7 +748,7 @@ static int wait_for_complete(struct loopback_test *t)
 		}
 
 		for (i = 0; i < t->poll_count; i++) {
-			if (t->fds[i].revents & EPOLLPRI) {
+			if (t->fds[i].revents & POLLPRI) {
 				/* Dummy read to clear the event */
 				read(t->fds[i].fd, &dummy, 1);
 				number_of_events++;
-- 
2.24.1

