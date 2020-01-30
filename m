Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 816B014DA2F
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 12:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgA3LxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 06:53:07 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50727 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727074AbgA3LxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 06:53:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580385183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+qTtaHPN/sKfwNnk+hJQ/UVpSyF6ed7CcXYktzWB+dM=;
        b=dtipbnU1gf2FG6kQqQrNKbNWhV0jgw7rbWQgOL9/vrFChjjnflcgAsA2iGR8Pknt8D83UO
        xAb5N5cUymebTgPT1Kacbacvqz3G4PuKRCt9/ICRpfsaxt9ByHWuYva8LzuDO1ewRyetLm
        cCJQra7kyK9K1Fcc6aXq1nLV0F3OtCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-N9tvSenHMzmNGlXSkD-gBg-1; Thu, 30 Jan 2020 06:53:01 -0500
X-MC-Unique: N9tvSenHMzmNGlXSkD-gBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9548107ACC7;
        Thu, 30 Jan 2020 11:52:59 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-64.ams2.redhat.com [10.36.117.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64C1787B21;
        Thu, 30 Jan 2020 11:52:57 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Vipul Kumar <vipulk0511@gmail.com>,
        Vipul Kumar <vipul_kumar@mentor.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Srikanth Krishnakar <Srikanth_Krishnakar@mentor.com>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] x86/tsc_msr: Use named struct initializers
Date:   Thu, 30 Jan 2020 12:52:53 +0100
Message-Id: <20200130115255.20840-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Use named struct initializers for the freq_desc struct-s initialization
and change the "u8 msr_plat" to a "bool use_msr_plat" to make its meaning
more clear instead of relying on a comment to explain it.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/x86/kernel/tsc_msr.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index e0cbe4f2af49..5fa41ac3feb1 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -22,10 +22,10 @@
  * read in MSR_PLATFORM_ID[12:8], otherwise in MSR_PERF_STAT[44:40].
  * Unfortunately some Intel Atom SoCs aren't quite compliant to this,
  * so we need manually differentiate SoC families. This is what the
- * field msr_plat does.
+ * field use_msr_plat does.
  */
 struct freq_desc {
-	u8 msr_plat;	/* 1: use MSR_PLATFORM_INFO, 0: MSR_IA32_PERF_STATUS */
+	bool use_msr_plat;
 	u32 freqs[MAX_NUM_FREQS];
 };
=20
@@ -35,31 +35,39 @@ struct freq_desc {
  * by MSR based on SDM.
  */
 static const struct freq_desc freq_desc_pnw =3D {
-	0, { 0, 0, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat =3D false,
+	.freqs =3D { 0, 0, 0, 0, 0, 99840, 0, 83200 },
 };
=20
 static const struct freq_desc freq_desc_clv =3D {
-	0, { 0, 133200, 0, 0, 0, 99840, 0, 83200 }
+	.use_msr_plat =3D false,
+	.freqs =3D { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
 };
=20
 static const struct freq_desc freq_desc_byt =3D {
-	1, { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 }
+	.use_msr_plat =3D true,
+	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
 };
=20
 static const struct freq_desc freq_desc_cht =3D {
-	1, { 83300, 100000, 133300, 116700, 80000, 93300, 90000, 88900, 87500 }
+	.use_msr_plat =3D true,
+	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
+		   88900, 87500 },
 };
=20
 static const struct freq_desc freq_desc_tng =3D {
-	1, { 0, 100000, 133300, 0, 0, 0, 0, 0 }
+	.use_msr_plat =3D true,
+	.freqs =3D { 0, 100000, 133300, 0, 0, 0, 0, 0 },
 };
=20
 static const struct freq_desc freq_desc_ann =3D {
-	1, { 83300, 100000, 133300, 100000, 0, 0, 0, 0 }
+	.use_msr_plat =3D true,
+	.freqs =3D { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
 };
=20
 static const struct freq_desc freq_desc_lgm =3D {
-	1, { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 }
+	.use_msr_plat =3D true,
+	.freqs =3D { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
 };
=20
 static const struct x86_cpu_id tsc_msr_cpu_ids[] =3D {
@@ -91,7 +99,7 @@ unsigned long cpu_khz_from_msr(void)
 		return 0;
=20
 	freq_desc =3D (struct freq_desc *)id->driver_data;
-	if (freq_desc->msr_plat) {
+	if (freq_desc->use_msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);
 		ratio =3D (lo >> 8) & 0xff;
 	} else {
--=20
2.24.1

