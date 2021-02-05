Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E68A311516
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhBEWXT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbhBEOZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Feb 2021 09:25:16 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2AECC0617A9
        for <stable@vger.kernel.org>; Fri,  5 Feb 2021 08:03:23 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a12so10643596lfb.1
        for <stable@vger.kernel.org>; Fri, 05 Feb 2021 08:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b5md+VM0Kj9nJuyEfrlaC47wb1abRoUd9wa/zEOHKhs=;
        b=F96+d61g0zKMlcSQwUHXp0VNXHyBJ5CzZaYKJQqfOjxC4U3o/ISczJ56ISnAh4Yuvt
         pgBeiAnfwgtnbO/pZoh89HNRqbdWXbaZnUBC4GQt4m7uBPi+/sm9YAV0btuHia9pWNL+
         HezX9YQp/M0Lo845FLxEhhVo8hUjYj1EAMuKWtRdJlChgZwGBbJaO9ThAaZU2l82IHc/
         +1DxVJRelXDrrtrqFsGblJwIjgwZye7OWQJev72ERpGwT06d62wkysEwGUHATxK5oIKn
         DemLWUtMGMhmcD68D23SAXqyv6MLH5V9JCG/Ns3NDjnRHQW80SQDF4ZDhQoEglGNyXnN
         HfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b5md+VM0Kj9nJuyEfrlaC47wb1abRoUd9wa/zEOHKhs=;
        b=uMlp9PCYK5O7++VHdQmURTSe+hQ6iSPZYbOOWGeFShBMFt995Uq5Rkj0LM6RndhHaG
         J0jQF3uIfPUdDwmAssYXgzFNrSVkkawO0BdK9Wq1cityQTVquszEzJi55ADYmR6+XAgo
         96IZZq53K66xb0y6t6GSPv7Vvu86zeT82KgKjR7sgh//TmuVKEOCJ05HEk6vz+vYM3aw
         i1P5nqza0qx+2D23KMQ8hTnYjlw71td3uKllP7hMhyIO+JI9/r6FOPS+Z+P4Qj9ugQit
         IWrY90vhhW6qSb2CkYpSAeNzPlutsq8yu2nzMLrsz3hXed/6MIMQy3P44oWhAtnwv9KE
         aT+w==
X-Gm-Message-State: AOAM532tpaYSaPntk2B3bVBB50vHVDKw4pVcYex9t7xZrzGBIrXviYwZ
        /6Ig2+QsbX+uQT3GOIzOSMIOmSsbmKHkPg==
X-Google-Smtp-Source: ABdhPJyYpXb+OreVac+ebqH8TNYen1GOC9ExnXkhb2qKAfrjtxysPo4sA4d3gCcMCeKeMrUy0x2eUw==
X-Received: by 2002:a50:9310:: with SMTP id m16mr3747919eda.94.1612534382782;
        Fri, 05 Feb 2021 06:13:02 -0800 (PST)
Received: from jwang-Latitude-5491.fritz.box ([2001:16b8:496d:ac00:2cf3:6033:5ed5:ddc8])
        by smtp.gmail.com with ESMTPSA id w3sm3986406eja.52.2021.02.05.06.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:13:02 -0800 (PST)
From:   Jack Wang <jinpu.wang@cloud.ionos.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Cc:     Xiao Ni <xni@redhat.com>, David Jeffery <djeffery@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: [stable-5.10] md: Set prev_flush_start and flush_bio in an atomic way
Date:   Fri,  5 Feb 2021 15:13:01 +0100
Message-Id: <20210205141301.71682-1-jinpu.wang@cloud.ionos.com>
X-Mailer: git-send-email 2.25.1
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
index ea139d0c0bc3..2bd60bd9e2ca 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
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

