Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117EC1533F2
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 16:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgBEPem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 10:34:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46420 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727452AbgBEPem (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 10:34:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ptOhuL5N9YzCztFz4QinQ1jIP/KqqWPVWUnhqMHDGE=;
        b=fKhPz4xr5mKxYnRvewjNDqaL7sjzoJeF8DI1E/u/qoUkdlXL5qWNwKxZ8FHP8x7sI1iZlT
        DBnzyWqaHT/stZ2r68X+2mFc0ol4UyNv4FAJP77xesdf5Ibm+SBwho1dk8FMFfdFmLH9DK
        dtGUALxZxNZPELTNQtzFb/ZY/uDWj+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-sLY8mLuTOqCKMVg1z_sREA-1; Wed, 05 Feb 2020 10:34:39 -0500
X-MC-Unique: sLY8mLuTOqCKMVg1z_sREA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B134800D54;
        Wed,  5 Feb 2020 15:34:37 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-116-179.ams2.redhat.com [10.36.116.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10B10857AE;
        Wed,  5 Feb 2020 15:34:34 +0000 (UTC)
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
Subject: [PATCH v2 2/3] x86/tsc_msr: Fix MSR_FSB_FREQ mask for Cherry Trail devices
Date:   Wed,  5 Feb 2020 16:34:27 +0100
Message-Id: <20200205153428.437087-3-hdegoede@redhat.com>
In-Reply-To: <20200205153428.437087-1-hdegoede@redhat.com>
References: <20200205153428.437087-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the "Intel 64 and IA-32 Architectures Software Developer=E2=80=
=99s
Manual Volume 4: Model-Specific Registers" on Cherry Trail (Airmont)
devices the 4 lowest bits of the MSR_FSB_FREQ mask indicate the bus freq
unlike on e.g. Bay Trail where only the lowest 3 bits are used.

This is also the reason why MAX_NUM_FREQS is defined as 9, since
Cherry Trail SoCs have 9 possible frequencies, so we need to mask
the lo value from the MSR with 0x0f, not with 0x07 otherwise the
9th frequency will get interpreted as the 1st.

This commits bumps MAX_NUM_FREQS to 16 to avoid any possibility of
addressing the array out of bounds and makes the mask part of
the cpufreq struct so that we can set it per model.

While at it also log an error when the index points to an uninitialized
part of the freqs lookup-table.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/x86/kernel/tsc_msr.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 5fa41ac3feb1..95030895fffa 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -15,7 +15,7 @@
 #include <asm/param.h>
 #include <asm/tsc.h>
=20
-#define MAX_NUM_FREQS	9
+#define MAX_NUM_FREQS	16 /* 4 bits to select the frequency */
=20
 /*
  * If MSR_PERF_STAT[31] is set, the maximum resolved bus ratio can be
@@ -27,6 +27,7 @@
 struct freq_desc {
 	bool use_msr_plat;
 	u32 freqs[MAX_NUM_FREQS];
+	u32 mask;
 };
=20
 /*
@@ -37,37 +38,44 @@ struct freq_desc {
 static const struct freq_desc freq_desc_pnw =3D {
 	.use_msr_plat =3D false,
 	.freqs =3D { 0, 0, 0, 0, 0, 99840, 0, 83200 },
+	.mask =3D 0x07,
 };
=20
 static const struct freq_desc freq_desc_clv =3D {
 	.use_msr_plat =3D false,
 	.freqs =3D { 0, 133200, 0, 0, 0, 99840, 0, 83200 },
+	.mask =3D 0x07,
 };
=20
 static const struct freq_desc freq_desc_byt =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 0, 0, 0 },
+	.mask =3D 0x07,
 };
=20
 static const struct freq_desc freq_desc_cht =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 83300, 100000, 133300, 116700, 80000, 93300, 90000,
 		   88900, 87500 },
+	.mask =3D 0x0f,
 };
=20
 static const struct freq_desc freq_desc_tng =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 0, 100000, 133300, 0, 0, 0, 0, 0 },
+	.mask =3D 0x07,
 };
=20
 static const struct freq_desc freq_desc_ann =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 83300, 100000, 133300, 100000, 0, 0, 0, 0 },
+	.mask =3D 0x0f,
 };
=20
 static const struct freq_desc freq_desc_lgm =3D {
 	.use_msr_plat =3D true,
 	.freqs =3D { 78000, 78000, 78000, 78000, 78000, 78000, 78000, 78000 },
+	.mask =3D 0x0f,
 };
=20
 static const struct x86_cpu_id tsc_msr_cpu_ids[] =3D {
@@ -93,6 +101,7 @@ unsigned long cpu_khz_from_msr(void)
 	const struct freq_desc *freq_desc;
 	const struct x86_cpu_id *id;
 	unsigned long res;
+	int index;
=20
 	id =3D x86_match_cpu(tsc_msr_cpu_ids);
 	if (!id)
@@ -109,13 +118,17 @@ unsigned long cpu_khz_from_msr(void)
=20
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
+	index =3D lo & freq_desc->mask;
=20
 	/* Map CPU reference clock freq ID(0-7) to CPU reference clock freq(KHz=
) */
-	freq =3D freq_desc->freqs[lo & 0x7];
+	freq =3D freq_desc->freqs[index];
=20
 	/* TSC frequency =3D maximum resolved freq * maximum resolved bus ratio=
 */
 	res =3D freq * ratio;
=20
+	if (freq =3D=3D 0)
+		pr_err("Error MSR_FSB_FREQ index %d is unknown\n", index);
+
 #ifdef CONFIG_X86_LOCAL_APIC
 	lapic_timer_period =3D (freq * 1000) / HZ;
 #endif
--=20
2.24.1

