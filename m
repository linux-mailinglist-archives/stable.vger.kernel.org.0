Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0812017FF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388851AbgFSQp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:45:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388265AbgFSOln (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:41:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 820D02070A;
        Fri, 19 Jun 2020 14:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577703;
        bh=iYcUc5HN59kMLG7HGWR4iAb5BV2kngmF0II5snlSSQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KB+yJbb/6PoBuEZAvRXNLZf0+D2no1H2gTM0KXW66ZuSbq3caB1PsI/VDDXTJiw0C
         d71J0hQbxaI2xTfrkYRzQ4w1OmDEHGBvPHu4Rauxos+Wy+Pg08WnzoeN5GZiNYJhDP
         4K3qLzrMm5p45+6GiIjvlzDAlJFNAfuKliQoDIoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 4.9 053/128] media: dvb_frontend: ensure that inital front end status initialized
Date:   Fri, 19 Jun 2020 16:32:27 +0200
Message-Id: <20200619141623.012586497@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit a9e4998073d49a762a154a6b48a332ec6cb8e6b1 upstream.

The fe_status variable s is not initialized meaning it can have any
random garbage status.  This could be problematic if fe->ops.tune is
false as s is not updated by the call to fe->ops.tune() and a
subsequent check on the change status will using a garbage value.
Fix this by adding FE_NONE to the enum fe_status and initializing
s to this.

Detected by CoverityScan, CID#112887 ("Uninitialized scalar variable")

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Shuah Khan <shuahkh@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-core/dvb_frontend.c |    2 +-
 include/uapi/linux/dvb/frontend.h     |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -629,7 +629,7 @@ static int dvb_frontend_thread(void *dat
 	struct dvb_frontend *fe = data;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	enum fe_status s;
+	enum fe_status s = FE_NONE;
 	enum dvbfe_algo algo;
 	bool re_tune = false;
 	bool semheld = false;
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -127,6 +127,7 @@ enum fe_sec_mini_cmd {
  *			to reset DiSEqC, tone and parameters
  */
 enum fe_status {
+	FE_NONE			= 0x00,
 	FE_HAS_SIGNAL		= 0x01,
 	FE_HAS_CARRIER		= 0x02,
 	FE_HAS_VITERBI		= 0x04,


