Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20EC1FDB73
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbgFRBLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728783AbgFRBLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0EE2193E;
        Thu, 18 Jun 2020 01:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442704;
        bh=vBCBMzp/dJxu7P6BbPG/qZxbQff9ivykBWjmPDcspNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L+4460dC2NVk/0LwIaikLKDXVfmmIvISp3wx1yKLCWRgaX+fwqSUxPtgPo3R8Holt
         WfssjV8JyyJ/bDHyLbFnOfHbP0+SsUYFUnsItjMTkyKozWEarfVOz8vZCAfR0fty09
         WjmBeoyNOH8B/srJ8BzlozK/TCk4d9un4/V6C6ZM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 166/388] HID: intel-ish-hid: avoid bogus uninitialized-variable warning
Date:   Wed, 17 Jun 2020 21:04:23 -0400
Message-Id: <20200618010805.600873-166-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 0b66fb3e6b7a53688f8e20945ac78cd3d832c65f ]

Older compilers like gcc-4.8 don't see that the variable is
initialized when it is used:

In file included from include/linux/compiler_types.h:68:0,
                 from <command-line>:0:
drivers/hid/intel-ish-hid/ishtp-fw-loader.c: In function 'load_fw_from_host':
include/linux/compiler-gcc.h:75:45: warning: 'fw_info.ldr_capability.max_dma_buf_size' may be used uninitialized in this function [-Wmaybe-uninitialized]
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
                                             ^
drivers/hid/intel-ish-hid/ishtp-fw-loader.c:770:22: note: 'fw_info.ldr_capability.max_dma_buf_size' was declared here
  struct shim_fw_info fw_info;
                      ^

Make sure to initialize it before returning an error from ish_query_loader_prop().

Fixes: 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader client driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
index aa2dbed30fc3..6cf59fd26ad7 100644
--- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
+++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
@@ -480,6 +480,7 @@ static int ish_query_loader_prop(struct ishtp_cl_data *client_data,
 			    sizeof(ldr_xfer_query_resp));
 	if (rv < 0) {
 		client_data->flag_retry = true;
+		*fw_info = (struct shim_fw_info){};
 		return rv;
 	}
 
@@ -489,6 +490,7 @@ static int ish_query_loader_prop(struct ishtp_cl_data *client_data,
 			"data size %d is not equal to size of loader_xfer_query_response %zu\n",
 			rv, sizeof(struct loader_xfer_query_response));
 		client_data->flag_retry = true;
+		*fw_info = (struct shim_fw_info){};
 		return -EMSGSIZE;
 	}
 
-- 
2.25.1

