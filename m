Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016AD3E9CCE
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 05:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhHLDR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 23:17:29 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:54514 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbhHLDR2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 23:17:28 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id AE520806B6;
        Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1628738222;
        bh=NeX3WmTZdfb7EA9aTn39dTlE4e9PDnx0Q0e5xdmq7Jo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=K1YA4CbxjZB4ftGwrHh2lGK4ZK5Sj0SSAUdKlBDOwZSFPzoG3bu2NPvZEXRK9aCtJ
         9En8b/dUDQJfewlCxM7Uq1opTmPPqVZCPL1/sy7Yz3yiSAblRiBB3gEnoq6cCnKu37
         VtIq1Ki6Hy6ynDXTsX0GlABBPhByl3KGGu04miy14rVt2Una7OzvQLMN1K8nmAr+1+
         jqYG2oOrc2pxr5WcIHbAjT2SqF24UlK7jaR+1AekkFh30SIdfpfvyySCYIk3piv0pB
         0vw4tZNVyKBrMJEFyFr4wVpnKmDLKTrQRDhqKzsZqZRtDKOmjgMqQVYUT+SytVSeZf
         YW3bVzXnEIbaw==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B611492ae0001>; Thu, 12 Aug 2021 15:17:02 +1200
Received: from pauld-dl.ws.atlnz.lc (pauld-dl.ws.atlnz.lc [10.33.23.37])
        by pat.atlnz.lc (Postfix) with ESMTP id 63BAC13EEA2;
        Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
Received: by pauld-dl.ws.atlnz.lc (Postfix, from userid 1684)
        id 581641E01E6; Thu, 12 Aug 2021 15:17:02 +1200 (NZST)
From:   Paul Davey <paul.davey@alliedtelesis.co.nz>
To:     Manivannan Sadhasivam <mani@kernel.org>
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Davey <paul.davey@alliedtelesis.co.nz>,
        stable@vger.kernel.org
Subject: [PATCH v4 1/2] bus: mhi: Fix pm_state conversion to string
Date:   Thu, 12 Aug 2021 15:16:59 +1200
Message-Id: <20210812031700.23397-2-paul.davey@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210812031700.23397-1-paul.davey@alliedtelesis.co.nz>
References: <20210812031700.23397-1-paul.davey@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=aqTM9hRV c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=LpQP-O61AAAA:8 a=xDYxNL215i3Ysd8OqoQA:9 a=AjGcO6oz07-iQ99wixmX:22 a=pioyyrs4ZptJ924tMmac:22
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On big endian architectures the mhi debugfs files which report pm state
give "Invalid State" for all states.  This is caused by using
find_last_bit which takes an unsigned long* while the state is passed in
as an enum mhi_pm_state which will be of int size.

Fix by using __fls to pass the value of state instead of find_last_bit.

Fixes: a6e2e3522f29 ("bus: mhi: core: Add support for PM state transition=
s")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Signed-off-by: Paul Davey <paul.davey@alliedtelesis.co.nz>
---
 drivers/bus/mhi/core/init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 5aaca6d0f52b..0d588b60929e 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -79,9 +79,12 @@ static const char * const mhi_pm_state_str[] =3D {
=20
 const char *to_mhi_pm_state_str(enum mhi_pm_state state)
 {
-	int index =3D find_last_bit((unsigned long *)&state, 32);
+	int index;
=20
-	if (index >=3D ARRAY_SIZE(mhi_pm_state_str))
+	if (state)
+		index =3D __fls(state);
+
+	if (!state || index >=3D ARRAY_SIZE(mhi_pm_state_str))
 		return "Invalid State";
=20
 	return mhi_pm_state_str[index];
--=20
2.32.0

