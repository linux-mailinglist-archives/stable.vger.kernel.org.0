Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357C44ABD81
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376276AbiBGLop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385190AbiBGLbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0C8C03FEE0;
        Mon,  7 Feb 2022 03:29:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82D126077B;
        Mon,  7 Feb 2022 11:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D58C004E1;
        Mon,  7 Feb 2022 11:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233373;
        bh=GS6MBhstiZFiTAX47S9HOYPrRvE1rIgmTK6Ds/8qu4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vz2MI98HlH63Wyrq7duaOcQ/cViXIuzS6ixFxzTiLFsYy6OWrUdS59Onaq/QQU5d8
         EyOHX+pjoSS9Mjk5favPOtchc0b87Jt7GuU5TqBoiA0lMvV9sivU9qW5eTldrKIAvc
         +zkcd8nzcZ3I0QMzWdS1eA5o5LAetDnPdWfo9IcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyue Wang <haiyue.wang@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 085/110] gve: fix the wrong AdminQ buffer queue index check
Date:   Mon,  7 Feb 2022 12:06:58 +0100
Message-Id: <20220207103805.285730669@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyue Wang <haiyue.wang@intel.com>

commit 1f84a9450d75e08af70d9e2f2d5e1c0ac0c881d2 upstream.

The 'tail' and 'head' are 'unsigned int' type free-running count, when
'head' is overflow, the 'int i (= tail) < u32 head' will be false:

Only '- loop 0: idx = 63' result is shown, so it needs to use 'int' type
to compare, it can handle the overflow correctly.

typedef uint32_t u32;

int main()
{
        u32 tail, head;
        int stail, shead;
        int i, loop;

        tail = 0xffffffff;
        head = 0x00000000;

        for (i = tail, loop = 0; i < head; i++) {
                unsigned int idx = i & 63;

                printf("+ loop %d: idx = %u\n", loop++, idx);
        }

        stail = tail;
        shead = head;
        for (i = stail, loop = 0; i < shead; i++) {
                unsigned int idx = i & 63;

                printf("- loop %d: idx = %u\n", loop++, idx);
        }

        return 0;
}

Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_adminq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -281,7 +281,7 @@ static int gve_adminq_parse_err(struct g
  */
 static int gve_adminq_kick_and_wait(struct gve_priv *priv)
 {
-	u32 tail, head;
+	int tail, head;
 	int i;
 
 	tail = ioread32be(&priv->reg_bar0->adminq_event_counter);


