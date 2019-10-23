Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A21E219D
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 19:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbfJWRSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 13:18:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39378 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728549AbfJWRSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 13:18:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id r141so10839472wme.4
        for <stable@vger.kernel.org>; Wed, 23 Oct 2019 10:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=48XDzmeFiM9yOQfqbOoh8NKzWofKTXbdxGBYN62jtKs=;
        b=K0hKL19qHw3J5tEam6YX1YovarKMfA3S6y4cNF77riVmCADwA/pXcYvmY0AeRHQ++Y
         jIRM4zjpusmWcKoGcs1aG+IZEIaqeUcXqXbxWbxyqAXzTYi8q2iFgrUS+HRVCAY45cwA
         OM+2clMI8peNxrDQUz6R18LprsOW4U7o1S9yUo1oU1nnr5EyvGHDwuvvgr2S70OeAlee
         nqzFU5+Qt9bYt1TvxhXxJjm5enxaXLlnBA+hFq9MOiJdtN6VSULqfbftc8LjaUPw3WRR
         JnAQXuWP7Es9gpasa98YAoNwV2rjgVR2XwUo9EYnWUVjRYrTdKrEXsNyY71PrfjfwBEU
         PTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=48XDzmeFiM9yOQfqbOoh8NKzWofKTXbdxGBYN62jtKs=;
        b=oArM6ZC4/z9ONE+BEGjSAtY8vGjymmiKmHbxUStN/BGsSYMbukYuH8AR6TjoHPalI8
         /X/HFgR3L4lcJ+OYNaMv9ZIBifk3xSook5JfuKmxoIX/P1c92NL2583xSqm/vEJzoGzH
         NwF8lPrdYgRF0QzmanOlr0EQpYdUtCudbjfVFinv+9F/mP9LOjF/n9LVHIIrVTTTt2Id
         wzdFWezTUeLP4lT1VgPUk45XgAiKVfNUk5TX8eCX7GsXuPY765RAwisfgn0YH+3bepWG
         U2I8xWhvIefd9ij4aDLtAA3lI+rFRkiVtHOS4EUQ9qUUgmamnqn2ty7sfiuG8ERcKV4e
         lAlQ==
X-Gm-Message-State: APjAAAW+cCuMu1C2eKkf1UKvDbrWfHT1B/+DpoliDcq77GotRCW+6ABY
        KlMM3HwS3kc+bG0UpNIA+YcznYk8cMJkz6jq
X-Google-Smtp-Source: APXvYqzNDT5y6csWeVLItVHdqJPlxCEQp3G7g/uwZZKeYuvL1K3rIgc2YTkz8U/QH+j0z4bPJx5fmQ==
X-Received: by 2002:a7b:c049:: with SMTP id u9mr931749wmc.12.1571851094909;
        Wed, 23 Oct 2019 10:18:14 -0700 (PDT)
Received: from balsini.lon.corp.google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id r65sm21571740wmr.9.2019.10.23.10.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 10:18:14 -0700 (PDT)
From:   Alessio Balsini <balsini@android.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Alessio Balsini <balsini@android.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 4.9 4.14] loop: Add LOOP_SET_DIRECT_IO to compat ioctl
Date:   Wed, 23 Oct 2019 18:17:36 +0100
Message-Id: <20191023171736.161697-1-balsini@android.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20190805115309.GJ2349@hirez.programming.kicks-ass.net>
References: <20190805115309.GJ2349@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fdbe4eeeb1aac219b14f10c0ed31ae5d1123e9b8 ]

Enabling Direct I/O with loop devices helps reducing memory usage by
avoiding double caching.  32 bit applications running on 64 bits systems
are currently not able to request direct I/O because is missing from the
lo_compat_ioctl.

This patch fixes the compatibility issue mentioned above by exporting
LOOP_SET_DIRECT_IO as additional lo_compat_ioctl() entry.
The input argument for this ioctl is a single long converted to a 1-bit
boolean, so compatibility is preserved.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index da3902ac16c86..8aadd4d0c3a88 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1557,6 +1557,7 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 		arg = (unsigned long) compat_ptr(arg);
 	case LOOP_SET_FD:
 	case LOOP_CHANGE_FD:
+	case LOOP_SET_DIRECT_IO:
 		err = lo_ioctl(bdev, mode, cmd, arg);
 		break;
 	default:
-- 
2.23.0.866.gb869b98d4c-goog

