Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FACA50510B
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbiDRMaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239005AbiDRM1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:27:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13C71E3E7;
        Mon, 18 Apr 2022 05:21:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65DF5B80EDC;
        Mon, 18 Apr 2022 12:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A754BC385A7;
        Mon, 18 Apr 2022 12:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284467;
        bh=aqaM+ASEtCO7ZYIvGnCWXwXUFuLPGL1pjwd3ZapU2y8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=okdvS+bOVrKPIFvIPtvJMlgez8wrnE9aFfR3mBzML0xwUCphZ1U7H+fYqjkB9o7v7
         o+EJ/rUf4P3sF/X74XmN3uFxh/sXr5tLLrzE0qn49uHqxBTcb6dfYU0etsYOfFVssH
         LyFtguSuKaFuIsS0Di3dkwmEUncJEVoA8OGDlPNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 124/219] net: dsa: felix: fix tagging protocol changes with multiple CPU ports
Date:   Mon, 18 Apr 2022 14:11:33 +0200
Message-Id: <20220418121210.368426795@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 00fa91bc9cc2a9d340f963af5e457610ad4b2f9c ]

When the device tree has 2 CPU ports defined, a single one is active
(has any dp->cpu_dp pointers point to it). Yet the second one is still a
CPU port, and DSA still calls ->change_tag_protocol on it.

On the NXP LS1028A, the CPU ports are ports 4 and 5. Port 4 is the
active CPU port and port 5 is inactive.

After the following commands:

 # Initial setting
 cat /sys/class/net/eno2/dsa/tagging
 ocelot
 echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
 echo ocelot > /sys/class/net/eno2/dsa/tagging

traffic is now broken, because the driver has moved the NPI port from
port 4 to port 5, unbeknown to DSA.

The problem can be avoided by detecting that the second CPU port is
unused, and not doing anything for it. Further rework will be needed
when proper support for multiple CPU ports is added.

Treat this as a bug and prepare current kernels to work in single-CPU
mode with multiple-CPU DT blobs.

Fixes: adb3dccf090b ("net: dsa: felix: convert to the new .change_tag_protocol DSA API")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20220412172209.2531865-1-vladimir.oltean@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9957772201d5..c414d9e9d7c0 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -599,6 +599,8 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	struct ocelot *ocelot = ds->priv;
 	struct felix *felix = ocelot_to_felix(ocelot);
 	enum dsa_tag_protocol old_proto = felix->tag_proto;
+	bool cpu_port_active = false;
+	struct dsa_port *dp;
 	int err;
 
 	if (proto != DSA_TAG_PROTO_SEVILLE &&
@@ -606,6 +608,27 @@ static int felix_change_tag_protocol(struct dsa_switch *ds, int cpu,
 	    proto != DSA_TAG_PROTO_OCELOT_8021Q)
 		return -EPROTONOSUPPORT;
 
+	/* We don't support multiple CPU ports, yet the DT blob may have
+	 * multiple CPU ports defined. The first CPU port is the active one,
+	 * the others are inactive. In this case, DSA will call
+	 * ->change_tag_protocol() multiple times, once per CPU port.
+	 * Since we implement the tagging protocol change towards "ocelot" or
+	 * "seville" as effectively initializing the NPI port, what we are
+	 * doing is effectively changing who the NPI port is to the last @cpu
+	 * argument passed, which is an unused DSA CPU port and not the one
+	 * that should actively pass traffic.
+	 * Suppress DSA's calls on CPU ports that are inactive.
+	 */
+	dsa_switch_for_each_user_port(dp, ds) {
+		if (dp->cpu_dp->index == cpu) {
+			cpu_port_active = true;
+			break;
+		}
+	}
+
+	if (!cpu_port_active)
+		return 0;
+
 	felix_del_tag_protocol(ds, cpu, old_proto);
 
 	err = felix_set_tag_protocol(ds, cpu, proto);
-- 
2.35.1



