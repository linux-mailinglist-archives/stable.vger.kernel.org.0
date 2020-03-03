Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F23177EEE
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731415AbgCCRrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:47:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:54702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgCCRro (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:47:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D43CD208C3;
        Tue,  3 Mar 2020 17:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257664;
        bh=RHF07HH/10+qbB+CsSVVFZKfwr43HSrnCB+OSo7B0FI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqHlIjlQhTyq0Fd+Nxyqi7k7rx8DvAzcWlBS6TFEvaI3HXGGzzaRGgbpot4Kn6hW6
         k8m8qne9RF5wo8rNhFiH6ailIl5Daj5tEzx3YdH1BcuH8KnhzTPsrkP+QvH3tpbxwT
         ook123pWKbqD0UPC26YJc7R/FUtWChMAMyJpXmco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.5 082/176] scsi: zfcp: fix wrong data and display format of SFP+ temperature
Date:   Tue,  3 Mar 2020 18:42:26 +0100
Message-Id: <20200303174314.133709004@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Block <bblock@linux.ibm.com>

commit a3fd4bfe85fbb67cf4ec1232d0af625ece3c508b upstream.

When implementing support for retrieval of local diagnostic data from the
FCP channel, the wrong data format was assumed for the temperature of the
local SFP+ connector. The Fibre Channel Link Services (FC-LS-3)
specification is not clear on the format of the stored integer, and only
after consulting the SNIA specification SFF-8472 did we realize it is
stored as two's complement. Thus, the used data and display format is
wrong, and highly misleading for users when the temperature should drop
below 0°C (however unlikely that may be).

To fix this, change the data format in `struct fsf_qtcb_bottom_port` from
unsigned to signed, and change the printf format string used to generate
`zfcp_sysfs_adapter_diag_sfp_temperature_show()` from `%hu` to `%hd`.

Link: https://lore.kernel.org/r/d6e3be5428da5c9490cfff4df7cae868bc9f1a7e.1582039501.git.bblock@linux.ibm.com
Fixes: a10a61e807b0 ("scsi: zfcp: support retrieval of SFP Data via Exchange Port Data")
Fixes: 6028f7c4cd87 ("scsi: zfcp: introduce sysfs interface for diagnostics of local SFP transceiver")
Cc: <stable@vger.kernel.org> # 5.5+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/scsi/zfcp_fsf.h   |    2 +-
 drivers/s390/scsi/zfcp_sysfs.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -410,7 +410,7 @@ struct fsf_qtcb_bottom_port {
 	u8 cb_util;
 	u8 a_util;
 	u8 res2;
-	u16 temperature;
+	s16 temperature;
 	u16 vcc;
 	u16 tx_bias;
 	u16 tx_power;
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -800,7 +800,7 @@ static ZFCP_DEV_ATTR(adapter_diag, b2b_c
 	static ZFCP_DEV_ATTR(adapter_diag_sfp, _name, 0400,		       \
 			     zfcp_sysfs_adapter_diag_sfp_##_name##_show, NULL)
 
-ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 6, "%hd");
 ZFCP_DEFINE_DIAG_SFP_ATTR(vcc, vcc, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_bias, tx_bias, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_power, tx_power, 5, "%hu");


