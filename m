Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6FD451E96
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbhKPAgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343871AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BA86339E;
        Mon, 15 Nov 2021 18:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002076;
        bh=odq/y+JYCzdPMIOo+K8Xx9cwJ4a9FATDI5/rCaDVnKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bd1C7KumCfm7KQvBvD1FXmkKvtczzIfTzTJQ/MDPBnNpL0gTa3A13m4A5q+K6Je07
         TKySTwkYdI2HmCwrxRVy8yqerqxlYFs5qo7Uma8qrSJtu6K6j9G+7TgXEiZtk2BAe9
         LAAllcDngpCELJM6Qva9N3GC0t8kLCL27BdAp8Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-um@lists.infradead.org, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 430/917] net: intel: igc_ptp: fix build for UML
Date:   Mon, 15 Nov 2021 17:58:45 +0100
Message-Id: <20211115165443.371123535@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 523994ba3ad1b7b55abe4a72e156897b5e2db825 ]

On a UML build, the igc_ptp driver uses CONFIG_X86_TSC for timestamp
conversion. The function that is used is not available on UML builds,
so have the function use the default system_counterval_t timestamp
instead for UML builds.

Prevents this build error on UML:

../drivers/net/ethernet/intel/igc/igc_ptp.c: In function ‘igc_device_tstamp_to_system’:
../drivers/net/ethernet/intel/igc/igc_ptp.c:777:9: error: implicit declaration of function ‘convert_art_ns_to_tsc’ [-Werror=implicit-function-declaration]
  return convert_art_ns_to_tsc(tstamp);
../drivers/net/ethernet/intel/igc/igc_ptp.c:777:9: error: incompatible types when returning type ‘int’ but ‘struct system_counterval_t’ was expected
  return convert_art_ns_to_tsc(tstamp);

Fixes: 68f5d3f3b654 ("um: add PCI over virtio emulation driver")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-um@lists.infradead.org
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: intel-wired-lan@lists.osuosl.org
Link: https://lore.kernel.org/r/20211014050516.6846-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0f021909b430a..30568e3544cda 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -773,7 +773,7 @@ static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
 
 static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
 {
-#if IS_ENABLED(CONFIG_X86_TSC)
+#if IS_ENABLED(CONFIG_X86_TSC) && !defined(CONFIG_UML)
 	return convert_art_ns_to_tsc(tstamp);
 #else
 	return (struct system_counterval_t) { };
-- 
2.33.0



