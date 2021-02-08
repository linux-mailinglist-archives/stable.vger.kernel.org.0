Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F131367D
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhBHPLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:11:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:25623 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233180AbhBHPHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:07:44 -0500
IronPort-SDR: JuaLT8piz4shZlXv5SnZ3liFF+DLxSu6XCFfcwTueTGGJ4njkY7erH/gst9JlmM5nOlOrBK75a
 DqgpggVdUNRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9888"; a="181871129"
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="181871129"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 07:07:04 -0800
IronPort-SDR: mkRsbQyU3E3f9hCdH1zSf8UEuNmTnN83q9XKoSbMon5eaqhShSD0/eLzGBMaPeybsS5tWF9jVe
 gl1+y8wHCNiQ==
X-IronPort-AV: E=Sophos;i="5.81,162,1610438400"; 
   d="scan'208";a="395414222"
Received: from twinkler-lnx.jer.intel.com ([10.12.91.138])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2021 07:07:02 -0800
From:   Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/2] mei: bus: block send with vtag on non-conformat FW
Date:   Mon,  8 Feb 2021 17:06:48 +0200
Message-Id: <20210208150649.141358-1-tomas.winkler@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Block data send with vtag if either transport layer or
FW client are not supporting vtags.

Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/bus.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 34fb5e541fe5..be99bb0a16cf 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -61,6 +61,13 @@ ssize_t __mei_cl_send(struct mei_cl *cl, u8 *buf, size_t length, u8 vtag,
 		goto out;
 	}
 
+	if (vtag) {
+		/* Check if vtag is supported by client */
+		rets = mei_cl_vt_support_check(cl);
+		if (rets)
+			goto out;
+	}
+
 	if (length > mei_cl_mtu(cl)) {
 		rets = -EFBIG;
 		goto out;
-- 
2.26.2

