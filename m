Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E51F15791A
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgBJNMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:12:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728188AbgBJMiu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:50 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 158502080C;
        Mon, 10 Feb 2020 12:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338330;
        bh=JaWlXpkIDT40oQ0O8RI5BvpQsxtpy9LWzAt/luAYnBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bWoisns4XAnwYxh8YozH3DuFkFghhq2iiq8Con7Ip60WgH728vupAQ4iktNoSVMhw
         D5Ro8JB4shftnq/4+66jHZOPlDP8Aof+vPXrdFeAnHNUdDuhKSBVYoAczwoPJWojsY
         0WqttoVG5lEFK89uGEXBnChmycQaSixurBler0I4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 264/309] devlink: report 0 after hitting end in region read
Date:   Mon, 10 Feb 2020 04:33:40 -0800
Message-Id: <20200210122432.032004166@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit d5b90e99e1d51b7b5d2b74fbc4c2db236a510913 ]

commit fdd41ec21e15 ("devlink: Return right error code in case of errors
for region read") modified the region read code to report errors
properly in unexpected cases.

In the case where the start_offset and ret_offset match, it unilaterally
converted this into an error. This causes an issue for the "dump"
version of the command. In this case, the devlink region dump will
always report an invalid argument:

000000000000ffd0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
000000000000ffe0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
devlink answers: Invalid argument
000000000000fff0 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

This occurs because the expected flow for the dump is to return 0 after
there is no further data.

The simplest fix would be to stop converting the error code to -EINVAL
if start_offset == ret_offset. However, avoid unnecessary work by
checking for when start_offset is larger than the region size and
returning 0 upfront.

Fixes: fdd41ec21e15 ("devlink: Return right error code in case of errors for region read")
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3863,6 +3863,12 @@ static int devlink_nl_cmd_region_read_du
 		goto out_unlock;
 	}
 
+	/* return 0 if there is no further data to read */
+	if (start_offset >= region->size) {
+		err = 0;
+		goto out_unlock;
+	}
+
 	hdr = genlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
 			  &devlink_nl_family, NLM_F_ACK | NLM_F_MULTI,
 			  DEVLINK_CMD_REGION_READ);


