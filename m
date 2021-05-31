Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0933960C3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233372AbhEaOb3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233774AbhEaO3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94CC261C24;
        Mon, 31 May 2021 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468898;
        bh=FkMhq74uK3etKdSivx+MQ8g7r+DNORyT/QYAvYZA+Ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wn0XdwkfF15ZYZNBSDBOkbgb+R1yE+ZASE24/cWIOpPih32b19PIf+6kb05FaexOj
         rze3unbzJDlE8pHfbAlSOjkJten5K1smn60Q7CE4vBfso7aTL3Df4pApgJ9uCDHMsf
         y5Ij4v+dW6WJnmg1t3JMa/4tjRcfyGXhZnJ5rkR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 171/177] i915: fix build warning in intel_dp_get_link_status()
Date:   Mon, 31 May 2021 15:15:28 +0200
Message-Id: <20210531130653.837840180@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

There is a build warning using gcc-11 showing a mis-match in the .h and .c
definitions of intel_dp_get_link_status():
  CC [M]  drivers/gpu/drm/i915/display/intel_dp.o
drivers/gpu/drm/i915/display/intel_dp.c:4139:56: warning: argument 2 of type ‘u8[6]’ {aka ‘unsigned char[6]’} with mismatched bound [-Warray-parameter=]
 4139 | intel_dp_get_link_status(struct intel_dp *intel_dp, u8 link_status[DP_LINK_STATUS_SIZE])
      |                                                     ~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from drivers/gpu/drm/i915/display/intel_dp.c:51:
drivers/gpu/drm/i915/display/intel_dp.h:105:57: note: previously declared as ‘u8 *’ {aka ‘unsigned char *’}
  105 | intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status);
      |                                                     ~~~~^~~~~~~~~~~

This was fixed accidentally commit b30edfd8d0b4 ("drm/i915: Switch to LTTPR
non-transparent mode link training") by getting rid of the function entirely,
but that is not a viable backport for a stable kernel, so just fix up the
function definition to remove the build warning entirely.  There is no
functional change for this, and it fixes up one of the last 'make allmodconfig'
build warnings when using gcc-11 on this kernel tree.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3634,7 +3634,7 @@ static void chv_dp_post_pll_disable(stru
  * link status information
  */
 bool
-intel_dp_get_link_status(struct intel_dp *intel_dp, u8 link_status[DP_LINK_STATUS_SIZE])
+intel_dp_get_link_status(struct intel_dp *intel_dp, u8 *link_status)
 {
 	return drm_dp_dpcd_read(&intel_dp->aux, DP_LANE0_1_STATUS, link_status,
 				DP_LINK_STATUS_SIZE) == DP_LINK_STATUS_SIZE;


