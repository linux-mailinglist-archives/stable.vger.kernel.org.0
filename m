Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53879206632
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388478AbgFWViv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:48358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387862AbgFWUHn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:07:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8FF02064B;
        Tue, 23 Jun 2020 20:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942862;
        bh=9IyFQ1LxdVrwBZSwUEShij5X2ILrV9XEJsqS8gNrNjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iW5BYNsHP9+PEBJIpi6boq/XGOhmjvhrtcpQQJBiWZo2417SQa5uKB6JfCQpDREPg
         WsaZ9xKW498CUwv/sJxH8SubaLq6R3y22pmH74V8wZjeyr8crROxzfzlsVpKnqX5YG
         NooegOHpjUoSSMIcneovmd3Q2m6qT5Gu5EbnF7hw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 163/477] HID: intel-ish-hid: avoid bogus uninitialized-variable warning
Date:   Tue, 23 Jun 2020 21:52:40 +0200
Message-Id: <20200623195415.292043791@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index aa2dbed30fc36..6cf59fd26ad78 100644
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



