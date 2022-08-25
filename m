Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED0035A1623
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242010AbiHYPxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 11:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiHYPxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 11:53:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3971B8F3D
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 08:53:03 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id az27so5155063wrb.6
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 08:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=eKDDvB8U6aq+7oIdAo/nTh9Y2n5hFUfH10TaK5bJglk=;
        b=f0zrJDDWE8ShnFKpgy/I8quIyXFiun0CkJ2ecWb//M/rWkjx4yYXXqkL5OdG3VL7DQ
         vWzmt0aUpqVkhJHGedjNyVEpc3064D+LeI+UTULNeUljk9V5pVSvm2+QoV1IgOKIzWoj
         +CJemXitxYgNnhGgNMH48eyLjfMrHUUfPBNEl9HWpxaMwLl9zQOozo5IkOinYQoKMvZO
         xksFratOhr3Q/tCYwVGoGFL/2xdH4GetlKt9h4rjNiyka8q+OsRYoKDi4+mvqbzlU+B2
         VL1tsqpizUxkknbkABQEKeh4QrqK6IWON5Cybr8ydwv5P2Rz9GClhpdo5AmO8mL2Ydhc
         WP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=eKDDvB8U6aq+7oIdAo/nTh9Y2n5hFUfH10TaK5bJglk=;
        b=dJDhSCxvOgKIYxMabpdjPqHHPQ2547HUmeJAReHb+r0XKhKT6frbO4xZI6j1jLnZp4
         xGVcBZbgf5hq1Cu2eafdf4QhkgUYRTWf3EMBQXodxIfJC4WpPhFNPrjEDYPVXoltiBUC
         fjSUKVK4EUQ0Ao0RO5nLY2o3/I3U8WVYgrCSKkShAHC4m7DsgEb456th4yUvqT/wMs00
         Ei2yUs13XtRE0sA67dT0K0aEfjJZaac1/po8HUO6uMvKzn4eHuq6ouHNUuCngVOfMAxL
         nsTGjSCxFutIC/pU6h3zMyFa3m4jGWeo+b+cWIv05HBo/3yEWz5E3EwAgZ0Sj58/SGYY
         juVQ==
X-Gm-Message-State: ACgBeo1p7GmvWogW3wlxAOUl7aUCcJPoPKf0aVdgw6GS0tr3egZ8nozA
        SJdzJOVTwliF/cIasnaEvvaKaw==
X-Google-Smtp-Source: AA6agR42in6A0RntamYZB9W+J0IKrhmHNMnAh6YXLyKNSDAp4ArNW922cMcaEHF9fVi6uWHXyxPGaQ==
X-Received: by 2002:a5d:6251:0:b0:222:cd3b:94bc with SMTP id m17-20020a5d6251000000b00222cd3b94bcmr2652113wrv.319.1661442782152;
        Thu, 25 Aug 2022 08:53:02 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id p20-20020a05600c419400b003a5ffec0b91sm5378284wmh.30.2022.08.25.08.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:53:01 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     joro@8bytes.org
Cc:     will@kernel.org, robin.murphy@arm.com,
        virtualization@lists.linux-foundation.org, iommu@lists.linux.dev,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v3] iommu/virtio: Fix interaction with VFIO
Date:   Thu, 25 Aug 2022 16:46:24 +0100
Message-Id: <20220825154622.86759-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit e8ae0e140c05 ("vfio: Require that devices support DMA cache
coherence") requires IOMMU drivers to advertise
IOMMU_CAP_CACHE_COHERENCY, in order to be used by VFIO. Since VFIO does
not provide to userspace the ability to maintain coherency through cache
invalidations, it requires hardware coherency. Advertise the capability
in order to restore VFIO support.

The meaning of IOMMU_CAP_CACHE_COHERENCY also changed from "IOMMU can
enforce cache coherent DMA transactions" to "IOMMU_CACHE is supported".
While virtio-iommu cannot enforce coherency (of PCIe no-snoop
transactions), it does support IOMMU_CACHE.

We can distinguish different cases of non-coherent DMA:

(1) When accesses from a hardware endpoint are not coherent. The host
    would describe such a device using firmware methods ('dma-coherent'
    in device-tree, '_CCA' in ACPI), since they are also needed without
    a vIOMMU. In this case mappings are created without IOMMU_CACHE.
    virtio-iommu doesn't need any additional support. It sends the same
    requests as for coherent devices.

(2) When the physical IOMMU supports non-cacheable mappings. Supporting
    those would require a new feature in virtio-iommu, new PROBE request
    property and MAP flags. Device drivers would use a new API to
    discover this since it depends on the architecture and the physical
    IOMMU.

(3) When the hardware supports PCIe no-snoop. It is possible for
    assigned PCIe devices to issue no-snoop transactions, and the
    virtio-iommu specification is lacking any mention of this.

    Arm platforms don't necessarily support no-snoop, and those that do
    cannot enforce coherency of no-snoop transactions. Device drivers
    must be careful about assuming that no-snoop transactions won't end
    up cached; see commit e02f5c1bb228 ("drm: disable uncached DMA
    optimization for ARM and arm64"). On x86 platforms, the host may or
    may not enforce coherency of no-snoop transactions with the physical
    IOMMU. But according to the above commit, on x86 a driver which
    assumes that no-snoop DMA is compatible with uncached CPU mappings
    will also work if the host enforces coherency.

    Although these issues are not specific to virtio-iommu, it could be
    used to facilitate discovery and configuration of no-snoop. This
    would require a new feature bit, PROBE property and ATTACH/MAP
    flags.

Cc: stable@vger.kernel.org
Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
Since v2 [1], I tried to refine the commit message.
This fix is needed for v5.19 and v6.0.

I can improve the check once Robin's change [2] is merged:
capable(IOMMU_CAP_CACHE_COHERENCY) could return dev->dma_coherent for
case (1) above.

[1] https://lore.kernel.org/linux-iommu/20220818163801.1011548-1-jean-philippe@linaro.org/
[2] https://lore.kernel.org/linux-iommu/d8bd8777d06929ad8f49df7fc80e1b9af32a41b5.1660574547.git.robin.murphy@arm.com/
---
 drivers/iommu/virtio-iommu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
index 08eeafc9529f..80151176ba12 100644
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -1006,7 +1006,18 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
 	return iommu_fwspec_add_ids(dev, args->args, 1);
 }
 
+static bool viommu_capable(enum iommu_cap cap)
+{
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static struct iommu_ops viommu_ops = {
+	.capable		= viommu_capable,
 	.domain_alloc		= viommu_domain_alloc,
 	.probe_device		= viommu_probe_device,
 	.probe_finalize		= viommu_probe_finalize,
-- 
2.37.1

