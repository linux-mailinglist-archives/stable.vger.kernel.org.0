Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD8119028
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 19:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727619AbfLJS4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 13:56:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50841 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727520AbfLJS4P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 13:56:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576004173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pKKP6PQdfmPaXtDmvgj9kKM8eTO86wVwsKrvHl8BN6w=;
        b=hSua+FKxZefdiFtM/VKdVvEUHJdd0JLMK3ClEKSmgEcBT7jcRTI1Gp/n5D6Hn4Mtf8Ngs7
        cIEbkTdXpky3tY/O02Sk+cmsqGz/msrzycNnq7Hw4dLY6n2tlWo6eSJ/rpiHzA5MZFOsJb
        XihDfJWyy6mtt57xtVixa/f6mtvNDpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-i3sAJY1kNVaA7JbYMKOm9Q-1; Tue, 10 Dec 2019 13:56:10 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D7F419057B1;
        Tue, 10 Dec 2019 18:56:09 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-117-41.phx2.redhat.com [10.3.117.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE6FF19C6A;
        Tue, 10 Dec 2019 18:56:08 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Joerg Roedel <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org, stable@vger.kernel.org
Subject: [PATCH] iommu: set group default domain before creating direct mappings
Date:   Tue, 10 Dec 2019 11:56:06 -0700
Message-Id: <20191210185606.11329-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: i3sAJY1kNVaA7JbYMKOm9Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

iommu_group_create_direct_mappings uses group->default_domain, but
right after it is called, request_default_domain_for_dev calls
iommu_domain_free for the default domain, and sets the group default
domain to a different domain. Move the
iommu_group_create_direct_mappings call to after the group default
domain is set, so the direct mappings get associated with that domain.

Cc: Joerg Roedel <jroedel@suse.de>
Cc: Lu Baolu <baolu.lu@linux.intel.com>=20
Cc: iommu@lists.linux-foundation.org
Cc: stable@vger.kernel.org
Fixes: 7423e01741dd ("iommu: Add API to request DMA domain for device")
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/iommu/iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index db7bfd4f2d20..fa908179b80b 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2282,13 +2282,13 @@ request_default_domain_for_dev(struct device *dev, =
unsigned long type)
 =09=09goto out;
 =09}
=20
-=09iommu_group_create_direct_mappings(group, dev);
-
 =09/* Make the domain the default for this group */
 =09if (group->default_domain)
 =09=09iommu_domain_free(group->default_domain);
 =09group->default_domain =3D domain;
=20
+=09iommu_group_create_direct_mappings(group, dev);
+
 =09dev_info(dev, "Using iommu %s mapping\n",
 =09=09 type =3D=3D IOMMU_DOMAIN_DMA ? "dma" : "direct");
=20
--=20
2.24.0

