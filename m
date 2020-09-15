Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86AC726B3A8
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgIOXHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727297AbgIOOlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:41:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2160D23D38;
        Tue, 15 Sep 2020 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180265;
        bh=KblMX/y8o/dzFzW01IDusdtYgXYg43ZSxCumVU57W6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNJavUM6HlzUtoa0BMVsRYcOeflnNt0i6cPPisGoWakiYyyTAL1Ws1I3AV2wfOajK
         Gtgz5FUbZQPxggRDwmZLyWgrkbnZ2/XYxXK9TyDMIfz8Sch2W9v2pZK7TEDF1LB6Nj
         C9cAj+Lg3jUIG9FpY5DXEw1Kv6LbtyOovYp5caQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Subject: [PATCH 5.8 173/177] usb: typec: intel_pmc_mux: Un-register the USB role switch
Date:   Tue, 15 Sep 2020 16:14:04 +0200
Message-Id: <20200915140701.991598905@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madhusudanarao Amara <madhusudanarao.amara@intel.com>

commit 290a405ce318d036666c4155d5899eb8cd6e0d97 upstream.

Added missing code for un-register USB role switch in the remove and
error path.

Cc: Stable <stable@vger.kernel.org> # v5.8
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Fixes: 6701adfa9693b ("usb: typec: driver for Intel PMC mux control")
Signed-off-by: Madhusudanarao Amara <madhusudanarao.amara@intel.com>
Link: https://lore.kernel.org/r/20200825183811.7262-1-madhusudanarao.amara@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/mux/intel_pmc_mux.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -441,6 +441,7 @@ err_remove_ports:
 	for (i = 0; i < pmc->num_ports; i++) {
 		typec_switch_unregister(pmc->port[i].typec_sw);
 		typec_mux_unregister(pmc->port[i].typec_mux);
+		usb_role_switch_unregister(pmc->port[i].usb_sw);
 	}
 
 	return ret;
@@ -454,6 +455,7 @@ static int pmc_usb_remove(struct platfor
 	for (i = 0; i < pmc->num_ports; i++) {
 		typec_switch_unregister(pmc->port[i].typec_sw);
 		typec_mux_unregister(pmc->port[i].typec_mux);
+		usb_role_switch_unregister(pmc->port[i].usb_sw);
 	}
 
 	return 0;


