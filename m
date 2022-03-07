Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B704CF851
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238579AbiCGJws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240064AbiCGJuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB9846B24;
        Mon,  7 Mar 2022 01:44:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28C8961052;
        Mon,  7 Mar 2022 09:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15661C340F3;
        Mon,  7 Mar 2022 09:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646243;
        bh=UVM/XEc3dj/uRbWktOGGecRDab/qgjKpsicqFCWm4Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UNRKGJCfCK53Elh/3OYrKFJ+W4CWAEKRWRvz0Pl7QiK1u8w1GmlTXbxL2p3z3H0Pa
         nzgeQnhyeblC1KOrm7ESUk7aTU5Os5GQk2RZ1v5/KBysEHBv5HU+uS/oaF5DuVi3Tq
         C8xNj1zSXzOj0/pKK17XBoHNzUZuW22dDpajRoj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slawomir Laba <slawomirx.laba@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 5.15 181/262] iavf: Fix deadlock in iavf_reset_task
Date:   Mon,  7 Mar 2022 10:18:45 +0100
Message-Id: <20220307091707.523317030@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slawomir Laba <slawomirx.laba@intel.com>

commit e85ff9c631e1bf109ce8428848dfc8e8b0041f48 upstream.

There exists a missing mutex_unlock call on crit_lock in
iavf_reset_task call path.

Unlock the crit_lock before returning from reset task.

Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2206,6 +2206,7 @@ static void iavf_reset_task(struct work_
 			reg_val);
 		iavf_disable_vf(adapter);
 		mutex_unlock(&adapter->client_lock);
+		mutex_unlock(&adapter->crit_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
 


