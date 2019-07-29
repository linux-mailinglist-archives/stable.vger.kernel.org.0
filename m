Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6361178779
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 10:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfG2Idy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 04:33:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40767 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfG2Idy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 04:33:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so60812285wrl.7
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 01:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1oADSOD4kjZ1dqW/2Ui0ZnHxXiMQh/ptauFbEpo8Vo8=;
        b=r6Umbo20Hap5YkpBHAoy7Vc3/ihU0piqjaCdPXTVL7nw+8vYKjAAzxohdcz9o/y51r
         TyrDkzFAs1R6ZHZ06c7O2BZMT6j/S4MCfalfInn14cvf0WWAHPzih3ZYjvLga/XFZiR/
         DvHsjlNNk1nD+JNTMGbENean0MjqOr/l1tK4708UbzMCUGm3b2PE3Q713mr+v3O1h9Kv
         HAZZXRXSF5JcftNmdjQV88kx67XoklUDEPaFDWkHhU37MR9YlxL3CjUx/VdTIBPyx3sL
         utvpItaXj0qSOAjdnZZIegVXlVhHo27Usofbwu/bsI4swva9jCg11XH9ViCVaFyozwR6
         ox6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1oADSOD4kjZ1dqW/2Ui0ZnHxXiMQh/ptauFbEpo8Vo8=;
        b=BaNlnrNFy+yBjGj+kS/iCTGt6wZ50yuWi9D5r17L2sJOTs6X8ZiLXviGMzEqcUxCcB
         uSqAw19rgkJdNVfXs1eYVc0SHM/UJ8Qreql8n8Ef+a7cq6OlE5vcEFlky6dC+HjxaYmy
         JCFD7isPIXHUQfLXuj+bHzsgKHKkc5uA7r+lTmicz1cQbTM8/GPNzl/yKkbC2gFpk+oj
         11MAUDkPOgXMQXlWKRFysoSa72trU+jnI6KkYB4q1oM9zA6QCsCpaFr3xBz3pipdGSDk
         UblKQfsoybKaaQz0XI7YICPe6UQm3Q4okgcCc7jhwJftfoi4QKRotMb8i56zu2UPE5P+
         8RFA==
X-Gm-Message-State: APjAAAW2HQZBmoA6//4lzVuR+NEM+s8JlGflIQgwCbD2GsoxU6yMIq+G
        1TOlwNzC2ZptqTnM2YJ02yOEHlKQuYA6mw==
X-Google-Smtp-Source: APXvYqxMGuL7m1YDC9Rc/HvOu4n6UhkpN7IQYCHtUlbxpWkT+Hyzhf2KVwI3s+e5tzMFeqXyaLcemA==
X-Received: by 2002:adf:e40e:: with SMTP id g14mr35397526wrm.161.1564389232614;
        Mon, 29 Jul 2019 01:33:52 -0700 (PDT)
Received: from gintonic.linbit ([2001:858:107:1:6428:48d1:352:f871])
        by smtp.gmail.com with ESMTPSA id b2sm77606191wrp.72.2019.07.29.01.33.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 29 Jul 2019 01:33:52 -0700 (PDT)
From:   =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        stable@vger.kernel.org
Subject: [PATCH] drbd: do not ignore signals in threads
Date:   Mon, 29 Jul 2019 10:32:48 +0200
Message-Id: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a regression introduced by upstream commit fee109901f39
('signal/drbd: Use send_sig not force_sig').

Currently, when a thread is initialized, all signals are set to be
ignored by default. DRBD uses SIGHUP to end its threads, which means it
is now no longer possible to bring down a DRBD resource because the
signals do not make it through to the thread in question.

This circumstance was previously hidden by the fact that DRBD used
force_sig() to kill its threads. The aforementioned upstream commit
changed this to send_sig(), which means the effects of the signals being
ignored by default are now becoming visible.

Thus, issue an allow_signal() at the start of the thread to explicitly
allow the desired signals.

Signed-off-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
Cc: stable@vger.kernel.org
---
 drivers/block/drbd/drbd_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9bd4ddd12b25..b8b986df6814 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -318,6 +318,9 @@ static int drbd_thread_setup(void *arg)
 	unsigned long flags;
 	int retval;
 
+	allow_signal(DRBD_SIGKILL);
+	allow_signal(SIGXCPU);
+
 	snprintf(current->comm, sizeof(current->comm), "drbd_%c_%s",
 		 thi->name[0],
 		 resource->name);
-- 
2.22.0

