Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A525836EEFC
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 19:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240884AbhD2Rfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 13:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236036AbhD2Rfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Apr 2021 13:35:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A369BC06138B
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i201-20020a25d1d20000b02904ed4c01f82bso24567222ybg.20
        for <stable@vger.kernel.org>; Thu, 29 Apr 2021 10:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aB9XBjTwrLlZovCpaC+C7umNB8F9B5TesXO6MUwGNrw=;
        b=r6odUMBLeTeEEQcPF2gnHzSCktqiR3GpcUJjpnFsxnBC291w+AlNCstJ7yQCeWyd/j
         qphfYAREJpOEywZAW29Nwx3FrcIDbGl7TXdsAzy+OOHQzLbxYXEOOFzUHHMbZrIPGnaw
         8GwNXZ4CyIhPzetkz9HqCvMYbSayE0mmsx+bAGY8jOP+Cy8Kf2MX4E/oJVDxB1FcEWPg
         0gr3sLwe8JabBXXAVdLtKVfRoFKkeNgWG/vMbggk4kTCqEcd5pcRmCn6ZckBXWurl/EJ
         55u51PPZgVK/hXtFIQf7c/gWdoOaF1gHpPr6mmBwbcFlM6KpiRAtYv0YmnS7X0sEtFoe
         orDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aB9XBjTwrLlZovCpaC+C7umNB8F9B5TesXO6MUwGNrw=;
        b=C7F002jpzxBpo5GfFNlJ/LtJFkCtvQwzrBzPLTZZNxwG/bJLdUgaUiJXGGSL+1uKRc
         aghKt6MQgp6w6PJhlY/7lcNma/wWCbI8xCKowSbPY/mIQ1ClrT/Nwhuk0D/c78YWMG+o
         I+rb2/2jVX4FCNKIQ4SeIPyMq++JhV+otMo5UD5iOE0UFqZpgGicOioOOSXYz45oxlpZ
         2tEyUNUhJl9pg2rRpvKBYfCVJDjaaQd7Torg5yVSXfiYPEC0P3J7e07vWv2+Q55gEn1o
         0xZxbF9ujWaT91vttHOTr7XHeYHRjQSdQzfAt2Qsmu0k7Khw9FouVrOdpUqZXLyLE0de
         XOXQ==
X-Gm-Message-State: AOAM530aNcVYEMiGTielld6MOAqZWk8mfV7Qx1K0IlWJsMMMEF/W39WG
        XY4MBwFfix9bFWg8XifqeHm/KrHFajEKc+DyBRVWv9v2bgcmHIkSbIirGYgg4xUxzh6XFa/8uVY
        goTChLbDOC4x+3kKrkb1E54ILhXSPrLczCBkOd1+eqa6+1HTTBmRoqJzm3MQ=
X-Google-Smtp-Source: ABdhPJxiq/TMhJJumHudoh6WOgrvt2itKoBVZ4ZX/cz4x9Askj2+8qypAeahdjwbF9qaHNkxoCvnVcpvYg==
X-Received: from jxgao-snp.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:1373])
 (user=jxgao job=sendgmr) by 2002:a25:af06:: with SMTP id a6mr975696ybh.255.1619717692892;
 Thu, 29 Apr 2021 10:34:52 -0700 (PDT)
Date:   Thu, 29 Apr 2021 17:33:15 +0000
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
Message-Id: <20210429173315.1252465-10-jxgao@google.com>
Mime-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 5.10 9/9] nvme-pci: set min_align_mask
From:   Jianxiong Gao <jxgao@google.com>
To:     stable@vger.kernel.org, hch@lst.de, marcorr@google.com,
        sashal@kernel.org
Cc:     Jianxiong Gao <jxgao@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit: 3d2d861eb03e8ee96dc430a54361c900cbe28afd

The PRP addressing scheme requires all PRP entries except for the
first one to have a zero offset into the NVMe controller pages (which
can be different from the Linux PAGE_SIZE).  Use the min_align_mask
device parameter to ensure that swiotlb does not change the address
of the buffer modulo the device page size to ensure that the PRPs
won't be malformed.

Signed-off-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Jianxiong Gao <jxgao@google.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4dca58f4afdf..716039ea4450 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2634,6 +2634,7 @@ static void nvme_reset_work(struct work_struct *work)
 	 * Don't limit the IOMMU merged segment size.
 	 */
 	dma_set_max_seg_size(dev->dev, 0xffffffff);
+	dma_set_min_align_mask(dev->dev, NVME_CTRL_PAGE_SIZE - 1);
 
 	mutex_unlock(&dev->shutdown_lock);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

