Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4BD2F150E
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbhAKNOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:14:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:60968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732004AbhAKNOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:14:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A03D2225E;
        Mon, 11 Jan 2021 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370807;
        bh=2b4XU79+d61t11FPQIDpQK6Z4qWCtEk3DBuTM3DuvvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRex1UC/Mk+zZ5rBKb/sXbbAArDF4w8l8kOcCXOvwSK/9YCAG4Wmn3pG4dYssiNWd
         z+SkK/NGdoFXd8irD8YjqXgIX5A0kZm1HcgZ7Q2dT9152yj4pmBpF3JefPDL6hhtHD
         uKKgFhlHDl2Bb8UEPdgFIy0iH23IwAHfrg8VWCWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 013/145] ibmvnic: fix login buffer memory leak
Date:   Mon, 11 Jan 2021 14:00:37 +0100
Message-Id: <20210111130049.152777381@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Pan <ljp@linux.ibm.com>

[ Upstream commit a0c8be56affa7d5ffbdec24c992223be54db3b6e ]

Commit 34f0f4e3f488 ("ibmvnic: Fix login buffer memory leaks") frees
login_rsp_buffer in release_resources() and send_login()
because handle_login_rsp() does not free it.
Commit f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in
ibmvnic_adapter struct") frees login_rsp_buffer in handle_login_rsp().
It seems unnecessary to free it in release_resources() and send_login().
There are chances that handle_login_rsp returns earlier without freeing
buffers. Double-checking the buffer is harmless since
release_login_buffer and release_login_rsp_buffer will
do nothing if buffer is already freed.

Fixes: f3ae59c0c015 ("ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct")
Fixes: 34f0f4e3f488 ("ibmvnic: Fix login buffer memory leaks")
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
Link: https://lore.kernel.org/r/20201219213919.21045-1-ljp@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -932,6 +932,7 @@ static void release_resources(struct ibm
 	release_rx_pools(adapter);
 
 	release_napi(adapter);
+	release_login_buffer(adapter);
 	release_login_rsp_buffer(adapter);
 }
 
@@ -3768,7 +3769,9 @@ static int send_login(struct ibmvnic_ada
 		return -1;
 	}
 
+	release_login_buffer(adapter);
 	release_login_rsp_buffer(adapter);
+
 	client_data_len = vnic_client_data_len(adapter);
 
 	buffer_size =


