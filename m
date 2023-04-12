Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6040B6DEF7C
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjDLIvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbjDLIvL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:51:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18F7127
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD6C963168
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF854C433EF;
        Wed, 12 Apr 2023 08:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289397;
        bh=+LqstMgJbyhO2RjVoqXsXpfm/5L4chwVDQQQh8Y41Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s2vLkw9B7wSATJf0EpkXnfVPed21U2Cr/3+Fwjp6S0rgniTEl7LeGXBILi0ylkSlj
         PsyA7+NPQeccWyiIBlNTLt2bJpWRD3W2wjdhYPZDJ1uVuhUKvPZRDPduXnJErQeHbN
         t+dk075qNTYnYE+4GHLJ/XTxzKwq7IkcCKgFrFWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ming Li <ming4.li@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [PATCH 6.2 056/173] cxl/pci: Handle truncated CDAT header
Date:   Wed, 12 Apr 2023 10:33:02 +0200
Message-Id: <20230412082840.391080977@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 34bafc747c54fb58c1908ec3116fa6137393e596 upstream.

cxl_cdat_get_length() only checks whether the DOE response size is
sufficient for the Table Access response header (1 dword), but not the
succeeding CDAT header (1 dword length plus other fields).

It thus returns whatever uninitialized memory happens to be on the stack
if a truncated DOE response with only 1 dword was received.  Fix it.

Fixes: c97006046c79 ("cxl/port: Read CDAT table")
Reported-by: Ming Li <ming4.li@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Ming Li <ming4.li@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: https://lore.kernel.org/r/000e69cd163461c8b1bc2cf4155b6e25402c29c7.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -528,7 +528,7 @@ static int cxl_cdat_get_length(struct de
 		return rc;
 	}
 	wait_for_completion(&t.c);
-	if (t.task.rv < sizeof(__le32))
+	if (t.task.rv < 2 * sizeof(__le32))
 		return -EIO;
 
 	*length = le32_to_cpu(t.response_pl[1]);


