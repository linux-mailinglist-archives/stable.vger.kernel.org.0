Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFD469CE15
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbjBTNzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjBTNzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:55:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F72218B39
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:55:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6AB1B80B4D
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:55:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29072C433EF;
        Mon, 20 Feb 2023 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676901343;
        bh=HGXOPkJV5VI+3Fy/YNsHIQd8deUfwoH/F63MFBoZN8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbUKlZCdy7In52afv3kzIh3SJT+BxJCRueKhzcQyGXnxMX4JZTVphQdnY6Bihh88L
         EaOAduMSgspYpAQWSfE3Kk8mU6JFjKZVBszgE3Z4WCiwlu0O6dTjWJr5c9ZyjANZDj
         DTzxyUdTJwo6vGtmnz+VbbYW2WPg9GIsrmipu8iY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hangyu Hua <hbh25y@gmail.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 38/57] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date:   Mon, 20 Feb 2023 14:36:46 +0100
Message-Id: <20230220133550.683682522@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133549.360169435@linuxfoundation.org>
References: <20230220133549.360169435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 2fa28f5c6fcbfc794340684f36d2581b4f2d20b5 upstream.

old_meter needs to be free after it is detached regardless of whether
the new meter is successfully attached.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Acked-by: Eelco Chaudron <echaudro@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/meter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -450,7 +450,7 @@ static int ovs_meter_cmd_set(struct sk_b
 
 	err = attach_meter(meter_tbl, meter);
 	if (err)
-		goto exit_unlock;
+		goto exit_free_old_meter;
 
 	ovs_unlock();
 
@@ -473,6 +473,8 @@ static int ovs_meter_cmd_set(struct sk_b
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
 	ovs_unlock();
 	nlmsg_free(reply);


