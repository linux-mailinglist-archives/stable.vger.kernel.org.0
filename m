Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F071C6DEE8E
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjDLImd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231159AbjDLImQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318DB6591
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1263A6306D
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4FEC433EF;
        Wed, 12 Apr 2023 08:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288896;
        bh=h9nPUCF1LhaT8A96J090/iUdOuSvI3+AqO1M64Kfrok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WITehfBnLJR/OL+Q6Zhqe0m7z+BSSIYn+WUCKuQOMWmO3cmiD0bcsMJfj6ZlpAoG3
         5cW9di/g3rj2rme9Q1PnOPhr7+ptySHEX1bhdEN+r44zQ8XYDVZMyGyghWDZaiO8G8
         Tgjx8tQqglF/H1egG1ZpGmel/Zvg2OWp4MT6Y690=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ira Weiny <ira.weiny@intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 059/164] cxl/pci: Handle excessive CDAT length
Date:   Wed, 12 Apr 2023 10:33:01 +0200
Message-Id: <20230412082839.331340803@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
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

commit 4fe2c13d59d849be3b45371e3913ec5dc77fc0fb upstream.

If the length in the CDAT header is larger than the concatenation of the
header and all table entries, then the CDAT exposed to user space
contains trailing null bytes.

Not every consumer may be able to handle that.  Per Postel's robustness
principle, "be liberal in what you accept" and silently reduce the
cached length to avoid exposing those null bytes.

Fixes: c97006046c79 ("cxl/port: Read CDAT table")
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: stable@vger.kernel.org # v6.0+
Link: https://lore.kernel.org/r/6d98b3c7da5343172bd3ccabfabbc1f31c079d74.1678543498.git.lukas@wunner.de
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -585,6 +585,9 @@ static int cxl_cdat_read_table(struct de
 		}
 	} while (entry_handle != CXL_DOE_TABLE_ACCESS_LAST_ENTRY);
 
+	/* Length in CDAT header may exceed concatenation of CDAT entries */
+	cdat->length -= length;
+
 	return 0;
 }
 


