Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1864395E89
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhEaOAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232890AbhEaN56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DD7761932;
        Mon, 31 May 2021 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468126;
        bh=9AvaqGLnlyi2BgaIA0cxJ9jFgmAFfSc9ddxMGWloVBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kooyeZwd3fV2Nya5rxiqTOsQtK6U6VMj+rbmSubIZiCEbi6ZaThjXaY1dxHglUMQh
         MiN9lAOzLlj5pAe80+kDZv6Qv3emuw8hmtROpMpkmzVWzsfcuC8xOiz8DoF7bYW1Aq
         ptoPpbAR5wFZskyH9HD6bLXtKoPO4ksD6OP4ciHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 127/252] mptcp: avoid error message on infinite mapping
Date:   Mon, 31 May 2021 15:13:12 +0200
Message-Id: <20210531130702.333602434@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 3ed0a585bfadb6bd7080f11184adbc9edcce7dbc upstream.

Another left-over. Avoid flooding dmesg with useless text,
we already have a MIB for that event.

Fixes: 648ef4b88673 ("mptcp: Implement MPTCP receive path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/subflow.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -740,7 +740,6 @@ static enum mapping_status get_mapping_s
 
 	data_len = mpext->data_len;
 	if (data_len == 0) {
-		pr_err("Infinite mapping not handled");
 		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		return MAPPING_INVALID;
 	}


