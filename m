Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B04E46D9
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 11:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408767AbfJYJO7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 05:14:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2407286AbfJYJO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 05:14:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571994898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2L00v1c62cEl8u7NqZzC34xau3XnczB1O0+AsHgHwSA=;
        b=UBAsgfZwBIvvc9rgIUYBwtZUR1kvSQFJsjhULNqCO/DOUjmPLovv8az+9775Eb4ltRuIqQ
        T5tFdEDNEM4ZNC4HGapD9XogH1TUIhzSPcOYQ59pfa/R5oHufoI5rOMgOW4BZ5E0fak0nz
        FP+9GpjZhE/PdLdW3+kqy8zMh9xio3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-D9yBAgzwMWWpE9g7FRBFWg-1; Fri, 25 Oct 2019 05:14:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECA96800D41;
        Fri, 25 Oct 2019 09:14:51 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-117-154.ams2.redhat.com [10.36.117.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CEF45D70E;
        Fri, 25 Oct 2019 09:14:50 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Hans de Goede <hdegoede@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] tpm: Switch to platform_get_irq_optional()
Date:   Fri, 25 Oct 2019 11:14:48 +0200
Message-Id: <20191025091448.4424-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: D9yBAgzwMWWpE9g7FRBFWg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

platform_get_irq() calls dev_err() on an error. As the IRQ usage in the
tpm_tis driver is optional, this is undesirable.

Specifically this leads to this new false-positive error being logged:
[    5.135413] tpm_tis MSFT0101:00: IRQ index 0 not found

This commit switches to platform_get_irq_optional(), which does not log
an error, fixing this.

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platfo=
rm_get_irq*()"
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
- Slightly reword commit msg, add Fixes tag
---
 drivers/char/tpm/tpm_tis.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index e4fdde93ed4c..e7df342a317d 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -286,7 +286,7 @@ static int tpm_tis_plat_probe(struct platform_device *p=
dev)
 =09}
 =09tpm_info.res =3D *res;
=20
-=09tpm_info.irq =3D platform_get_irq(pdev, 0);
+=09tpm_info.irq =3D platform_get_irq_optional(pdev, 0);
 =09if (tpm_info.irq <=3D 0) {
 =09=09if (pdev !=3D force_pdev)
 =09=09=09tpm_info.irq =3D -1;
--=20
2.23.0

