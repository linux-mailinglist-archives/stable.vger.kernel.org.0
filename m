Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EEC1CABC3
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgEHMqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729477AbgEHMqq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:46:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845C42495A;
        Fri,  8 May 2020 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942006;
        bh=FLBYZtiCowzv4AbyteownIRVO2OkjuxxoMl7KCtxlss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWGSUIRC+pTMTViHOu2SneiKEOFgv1DiPAdvFDcG4MH4U46SnVn6BhT6IuW13YL04
         04ugzfkHICNKAN2T9ZJ1jqWHKFyHL+ivmip96tnyvaidEDv5byabCpS84DbqPvtHza
         iLLbd6K1Aw5iT+v8/UwG0rRN8KLYM+6veCXgT4W0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bert Kenward <bkenward@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 258/312] sfc: clear napi_hash state when copying channels
Date:   Fri,  8 May 2020 14:34:09 +0200
Message-Id: <20200508123142.548509905@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bert Kenward <bkenward@solarflare.com>

commit 46d054f8f540612f09987a53154aa39ae15f2e4c upstream.

efx_copy_channel() doesn't correctly clear the napi_hash related state.
This means that when napi_hash_add is called for that channel nothing is
done, and we are left with a copy of the napi_hash_node from the old
channel. When we later call napi_hash_del() on this channel we have a
stale napi_hash_node.

Corruption is only seen when there are multiple entries in one of the
napi_hash lists. This is made more likely by having a very large number
of channels. Testing was carried out with 512 channels - 32 channels on
each of 16 ports.

This failure typically appears as protection faults within napi_by_id()
or napi_hash_add(). efx_copy_channel() is only used when tx or rx ring
sizes are changed (ethtool -G).

Fixes: 36763266bbe8 ("sfc: Add support for busy polling")
Signed-off-by: Bert Kenward <bkenward@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sfc/efx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -479,6 +479,9 @@ efx_copy_channel(const struct efx_channe
 	*channel = *old_channel;
 
 	channel->napi_dev = NULL;
+	INIT_HLIST_NODE(&channel->napi_str.napi_hash_node);
+	channel->napi_str.napi_id = 0;
+	channel->napi_str.state = 0;
 	memset(&channel->eventq, 0, sizeof(channel->eventq));
 
 	for (j = 0; j < EFX_TXQ_TYPES; j++) {


