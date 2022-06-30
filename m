Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E28561BDD
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235352AbiF3NuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235517AbiF3Ntb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:49:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FED535DC2;
        Thu, 30 Jun 2022 06:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B6D8B82AEF;
        Thu, 30 Jun 2022 13:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B37DC34115;
        Thu, 30 Jun 2022 13:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656596925;
        bh=ywZziMVk2wfYtFzokSeboHmjaNlpZjzTO3IiG/2bGEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zr9lPWZjH1JMdulmVsUDTStZ6ubRJ9GkOLm71QlnFvH6ErGHmirYhOWv+43HIQFOO
         0EhL19A2EEh8aWy9IwHEk8TcQp/oMZAB4GpuD8zUD2parhSy99jpPrnmzpgZQWo5t/
         G3yJM6iFsftNf8O9HGcR724UlTUbuxltfdEjwQN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Wu <edwardwu@realtek.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 4.9 03/29] ata: libata: add qc->flags in ata_qc_complete_template tracepoint
Date:   Thu, 30 Jun 2022 15:46:03 +0200
Message-Id: <20220630133231.303958872@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133231.200642128@linuxfoundation.org>
References: <20220630133231.200642128@linuxfoundation.org>
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
@@ -248,6 +248,7 @@ DECLARE_EVENT_CLASS(ata_qc_complete_temp
 		__entry->hob_feature	= qc->result_tf.hob_feature;
 		__entry->nsect		= qc->result_tf.nsect;
 		__entry->hob_nsect	= qc->result_tf.hob_nsect;
+		__entry->flags		= qc->flags;
 	),
 
 	TP_printk("ata_port=%u ata_dev=%u tag=%d flags=%s status=%s " \


