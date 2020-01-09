Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040B1136075
	for <lists+stable@lfdr.de>; Thu,  9 Jan 2020 19:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbgAIStU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jan 2020 13:49:20 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60096 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732156AbgAIStU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jan 2020 13:49:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578595758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X2h0R6xS52uSQnsEyxOMDBF/3vSZupo2+dOSewPV+DY=;
        b=LvJXdB+iZB7kazp+krx2UA8WJB9OC9oRY1diTyHocay7Iq1g+iYK1bunBH4+wiLqMIOZfq
        7CDO/ANtuZRp5AkXzdIfp6T/7AkdUVytnMKMsfintv2vK9D8Yp2UjHnQHzs5BTidWm4WcY
        hhKLnCAR3ko83qzE5oOzYoT5SLyPr2Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-1tPce08VNjmToOKxTs4KBg-1; Thu, 09 Jan 2020 13:49:15 -0500
X-MC-Unique: 1tPce08VNjmToOKxTs4KBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE482100724D;
        Thu,  9 Jan 2020 18:49:13 +0000 (UTC)
Received: from cantor.redhat.com (ovpn-116-184.phx2.redhat.com [10.3.116.184])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 291FC1A8E4;
        Thu,  9 Jan 2020 18:49:13 +0000 (UTC)
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     rhkernel-list@redhat.com
Cc:     stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Xiaoping Zhou <xiaoping.zhou@intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [RHEL8.2 PATCH BZ1789088 1/2] tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for interrupts"
Date:   Thu,  9 Jan 2020 11:48:58 -0700
Message-Id: <20200109184859.6755-2-jsnitsel@redhat.com>
In-Reply-To: <20200109184859.6755-1-jsnitsel@redhat.com>
References: <20200109184859.6755-1-jsnitsel@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bugzilla: 1789088
Upstream Status: dda8b2af395b2ed508e2ef314ae32e122841b447
Build Info: https://brewweb.engineering.redhat.com/brew/taskinfo?taskID=3D=
25656672

commit dda8b2af395b2ed508e2ef314ae32e122841b447
Author: Stefan Berger <stefanb@linux.ibm.com>
Date:   Tue Nov 26 08:17:52 2019 -0500

tpm: Revert "tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing for inter=
rupts"

There has been a bunch of reports (one from kernel bugzilla linked)
reporting that when this commit is applied it causes on some machines
boot freezes.

Unfortunately hardware where this commit causes a failure is not widely
available (only one I'm aware is Lenovo T490), which means we cannot
predict yet how long it will take to properly fix tpm_tis interrupt
probing.

Thus, the least worst short term action is to revert the code to the
state before this commit. In long term we need fix the tpm_tis probing
code to work on machines that Stefan's fix was supposed to fix.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D205935
Fixes: 1ea32c83c699 ("tpm_tis_core: Set TPM_CHIP_FLAG_IRQ before probing =
for interrupts")
Cc: stable@vger.kernel.org
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Tested-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Xiaoping Zhou <xiaoping.zhou@intel.com>
Signed-off-by: Stefan Berger <stefanb@linux.ibm.com>
Reported-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
(cherry picked from commit dda8b2af395b2ed508e2ef314ae32e122841b447)
Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
---
 drivers/char/tpm/tpm_tis_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_c=
ore.c
index 270f43acbb77..ffa9048d8f6c 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -981,7 +981,6 @@ int tpm_tis_core_init(struct device *dev, struct tpm_=
tis_data *priv, int irq,
 		}
=20
 		tpm_chip_start(chip);
-		chip->flags |=3D TPM_CHIP_FLAG_IRQ;
 		if (irq) {
 			tpm_tis_probe_irq_single(chip, intmask, IRQF_SHARED,
 						 irq);
--=20
2.24.0

