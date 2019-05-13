Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338321BC58
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 19:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfEMR4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 13:56:06 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36358 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbfEMR4G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 13:56:06 -0400
Received: by mail-it1-f196.google.com with SMTP id e184so464854ite.1
        for <stable@vger.kernel.org>; Mon, 13 May 2019 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svhcT8pZvlSPciWupxVEM8LrwN7z1JxmCsWJw2h9m9Q=;
        b=L6Sp30Ee6iOEZ20HswmHjqW+pc5tYPr/+pxzmXrK35gVCoHlkEW3X4csBatj/wttGg
         7rKLgXzkt3AlIz9ePO/+0Xr4N9AAYo+HeWcqr+tT1mdmEHkquxg3di5jwPtyaXd7o+n8
         /DZIWp+oXyM0EXcZOS9nhDL+5SGW+CM96vjVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svhcT8pZvlSPciWupxVEM8LrwN7z1JxmCsWJw2h9m9Q=;
        b=Mj1h5FLrmB6I9lVgX7PK6kWAAf4iULhYk3BpxXKeRAaZNL3WUYfpIJf7KxBm3uqpCl
         idW+d0drnT4cyov7fBbUKhtDcuPrTH3IpQLG4N9ziJl6jAXxLG58Vol5IxA1ncrqFTKB
         xNXFr4PO04DslSgjgQYo304b/zxlipN+bPZ9jfmMU3sgq3v8yKQ45Q2aH/Y9+QppgkjI
         H/HTF2pzj8GcVQRcNtytzH8xI5HOB5igSdKFmyCQffmvaoqlOzT5XZ19AwNyA98s1wxQ
         9umhtZK3PQYpkWfdMCfqlfgUtXwgdXpAl3DHIVp20xZ51OpfJHkI3oC0ebWaksBR7fBE
         9ROA==
X-Gm-Message-State: APjAAAXNf/U5m1rSNi6l5GpMAzly98OfKs5sQ+GWcU0OrOQV2FkJ8KA1
        w92Zg/H2PqKUTp+XIncN1j133XsjGps=
X-Google-Smtp-Source: APXvYqwlPT1j1z5u8J5ER885Ue1WqrIsSXOdmMWeu4Di3/W6jE76/mBB2+HjoV7zKSwUDk0NPgKpwg==
X-Received: by 2002:a24:5448:: with SMTP id t69mr335958ita.128.1557770165169;
        Mon, 13 May 2019 10:56:05 -0700 (PDT)
Received: from localhost ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id 129sm5318785iow.32.2019.05.13.10.56.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 10:56:04 -0700 (PDT)
From:   Raul E Rangel <rrangel@chromium.org>
To:     stable@vger.kernel.org
Cc:     linux-mmc@vger.kernel.org, djkurtz@google.com,
        adrian.hunter@intel.com, zwisler@chromium.org,
        Raul E Rangel <rrangel@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?UTF-8?q?Cl=C3=A9ment=20P=C3=A9ron?= <peron.clem@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak when shutting down request queue.
Date:   Mon, 13 May 2019 11:55:18 -0600
Message-Id: <20190513175521.84955-1-rrangel@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
potential resource leak when shutting down the request queue.

Once this patch is applied, there is a potential for a null pointer dereference.
That's what the second patch fixes.

The third patch is just an optimization to stop processing earlier.

See https://patchwork.kernel.org/patch/10925469/ for the initial motivation.

This commit applies to v4.14.116. It is already included in 4.19. 4.19 doesn't
suffer from the null pointer dereference because later commits migrate the mmc
stack to blk-mq.

I tested this patch set by randomly connecting/disconnecting the SD
card. I got over 189650 itarations without a problem.

Thanks,
Raul


Adrian Hunter (1):
  mmc: block: Simplify cleaning up the queue

Raul E Rangel (2):
  mmc: Fix null pointer dereference in mmc_init_request
  mmc: Kill the request if the queuedata has been removed

 drivers/mmc/core/block.c | 17 ++++++++++++-----
 drivers/mmc/core/queue.c | 14 +++++++++++---
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.21.0.1020.gf2820cf01a-goog

