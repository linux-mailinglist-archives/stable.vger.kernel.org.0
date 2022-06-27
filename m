Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02755C3F2
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbiF0LhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbiF0LgV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:36:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B671E1A;
        Mon, 27 Jun 2022 04:31:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B50AFB8111D;
        Mon, 27 Jun 2022 11:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B0BC3411D;
        Mon, 27 Jun 2022 11:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329515;
        bh=x7P22JytzPf6oNjq71S/evHGGCzh/+caYNfY3VnwaO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzTHizItndaCXAM9t+Czq2VMAECyItZfwcaxVAlv1+M7VSBNVUtJZQsh34FXyohi+
         7YAEpPcX5vkyw4N5QmQIpQwysZMaOcLkUt38+K1J14aZo34qi7tMT+sZNi56d3lLAS
         AmRIOlYzmBwrx/Zd3qbtWvAYSurqrjf6ebPy0uaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Wu <edwardwu@realtek.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 5.15 024/135] ata: libata: add qc->flags in ata_qc_complete_template tracepoint
Date:   Mon, 27 Jun 2022 13:20:31 +0200
Message-Id: <20220627111938.861856588@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111938.151743692@linuxfoundation.org>
References: <20220627111938.151743692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Wu <edwardwu@realtek.com>

commit 540a92bfe6dab7310b9df2e488ba247d784d0163 upstream.

Add flags value to check the result of ata completion

Fixes: 255c03d15a29 ("libata: Add tracepoints")
Cc: stable@vger.kernel.org
Signed-off-by: Edward Wu <edwardwu@realtek.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/libata.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -249,6 +249,7 @@ DECLARE_EVENT_CLASS(ata_qc_complete_temp
 		__entry->hob_feature	= qc->result_tf.hob_feature;
 		__entry->nsect		= qc->result_tf.nsect;
 		__entry->hob_nsect	= qc->result_tf.hob_nsect;
+		__entry->flags		= qc->flags;
 	),
 
 	TP_printk("ata_port=%u ata_dev=%u tag=%d flags=%s status=%s " \


