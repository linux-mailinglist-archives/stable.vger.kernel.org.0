Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924FA30DB02
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 14:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbhBCNVy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 08:21:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhBCNVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 08:21:53 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BEAC061793
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 05:20:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c12so24266486wrc.7
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 05:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EjmAutv15qjx2SSCkoRfIH3tCUPNl1e/xGS93BoqYcw=;
        b=TDUC8WIbHPI7UuTJJhAxsWWgUaMAvxRdo+om8WRkn3Sg9DFbiZldqsXGKOR6xovBkv
         ExLFvSMdYHLmPdHxiCEC9K3XNqBIRMfGGMQvSWPxEbptAn5gstpOvhUjMqDGzv/16vE2
         FAeCcJhe5xCvWem+dW2bzzrZZiPIeAQbmnk/7ylKtmiHEK4aurCNjicBfEPKYkQzNKET
         Vk4AQa2BaY8hkX+IorxsUwKW/89faFNpTzW63tZzwuBWcymlIUmtEYkyDejGNG871v+M
         vZseIsdFxZFQWvcVE6BljhSNRCCDL0HOoZ0dHXHHEF7SEM124mCwWUXTx6y+bg4fjjbf
         8S7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EjmAutv15qjx2SSCkoRfIH3tCUPNl1e/xGS93BoqYcw=;
        b=APeGuA3hx9zF9ayNhF+qutnsKOkM+66XAbsjJkp1js8GqkDg6UrefU0a4aHiMVtmR0
         /9MklEHHjC+SUMMSFGUrHnGkJsVGZ41o4akOTM43PFKQGbrVVWPO1jje0tmOH3LImECY
         BXKZwdZ6vXDnKonEZLEZCn3htXdT6tcGhuNK0pSd7Y/a6hSA5qqkcgW7Xt41h/3puMRg
         IId6baTr44oyronvQqHLHdzIlAsbwyDh/TWx9XwGr2LORN80ntz6x0KLg15pUtqSpMcG
         r/sw3gCkxergwbJ65N5Ax01BwJvHyIsHPhRJGjFgCTJj69bAluYj8I6sEktJEgCQV8YO
         I9YA==
X-Gm-Message-State: AOAM530/41n2IzISO2yJ5xaJT292LNmESPF7kkaBlU0DC+JSqShAcNjE
        IxERaqvMKJ2+mJllbFOkijrjBw==
X-Google-Smtp-Source: ABdhPJzKTnlsvFNop5UVZm8avHjVd9Y3pngfXtNQiKlz5VAYbEoMmUKHTAJuRnhQv1aY6JMOr7Iv2g==
X-Received: by 2002:a05:6000:8c:: with SMTP id m12mr3518190wrx.101.1612358431487;
        Wed, 03 Feb 2021 05:20:31 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:4947:3c00:7cf4:7472:391:9d0d])
        by smtp.gmail.com with ESMTPSA id d10sm3738430wrn.88.2021.02.03.05.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 05:20:30 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [stable-4.19 8/8] md: Set prev_flush_start and flush_bio in an atomic way
Date:   Wed,  3 Feb 2021 14:20:22 +0100
Message-Id: <20210203132022.92406-9-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
References: <20210203132022.92406-1-jinpu.wang@cloud.ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Ni <xni@redhat.com>

One customer reports a crash problem which causes by flush request. It
triggers a warning before crash.

        /* new request after previous flush is completed */
        if (ktime_after(req_start, mddev->prev_flush_start)) {
                WARN_ON(mddev->flush_bio);
                mddev->flush_bio = bio;
                bio = NULL;
        }

The WARN_ON is triggered. We use spin lock to protect prev_flush_start and
flush_bio in md_flush_request. But there is no lock protection in
md_submit_flush_data. It can set flush_bio to NULL first because of
compiler reordering write instructions.

For example, flush bio1 sets flush bio to NULL first in
md_submit_flush_data. An interrupt or vmware causing an extended stall
happen between updating flush_bio and prev_flush_start. Because flush_bio
is NULL, flush bio2 can get the lock and submit to underlayer disks. Then
flush bio1 updates prev_flush_start after the interrupt or extended stall.

Then flush bio3 enters in md_flush_request. The start time req_start is
behind prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't
finished). So it can trigger the WARN_ON now. Then it calls INIT_WORK
again. INIT_WORK() will re-initialize the list pointers in the
work_struct, which then can result in a corrupted work list and the
work_struct queued a second time. With the work list corrupted, it can
lead in invalid work items being used and cause a crash in
process_one_work.

We need to make sure only one flush bio can be handled at one same time.
So add spin lock in md_submit_flush_data to protect prev_flush_start and
flush_bio in an atomic way.

Reviewed-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
[jwang: backport dc5d17a3c39b06aef866afca19245a9cfb533a79 to 4.19]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 80ca13594c18..09f0d8e70b70 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -474,8 +474,10 @@ static void md_submit_flush_data(struct work_struct *ws)
 	 * could wait for this and below md_handle_request could wait for those
 	 * bios because of suspend check
 	 */
+	spin_lock_irq(&mddev->lock);
 	mddev->last_flush = mddev->start_flush;
 	mddev->flush_bio = NULL;
+	spin_unlock_irq(&mddev->lock);
 	wake_up(&mddev->sb_wait);
 
 	if (bio->bi_iter.bi_size == 0) {
-- 
2.25.1

