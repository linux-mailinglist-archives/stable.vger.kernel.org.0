Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DE84BE6EB
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343846AbiBUJma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351121AbiBUJmD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:42:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE8D3DDC4;
        Mon, 21 Feb 2022 01:17:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0A55CCE0E66;
        Mon, 21 Feb 2022 09:17:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7442C340E9;
        Mon, 21 Feb 2022 09:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435055;
        bh=6MdpUBQxcDitTQho4a+UV0MhACP/cQqImZDNH/2Z29w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VbHYUU54W+6iiraL5xAlvfTsHu11KXq5sWOwYh7npZRMKBs7gAeUxKbHI6CMkQSMI
         52E6PYJnEe8JC/xgMrPdjHZI0IfyKCHygOsvfezLXtKjcgvxDpvCre0Dts0oIv6giu
         DM1W60HpOCzuJLYkSm64WV4WrKuk9BzQflFhS5KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 028/227] btrfs: dont hold CPU for too long when defragging a file
Date:   Mon, 21 Feb 2022 09:47:27 +0100
Message-Id: <20220221084935.777644127@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Qu Wenruo <wqu@suse.com>

commit ea0eba69a2a8125229b1b6011644598039bc53aa upstream.

There is a user report about "btrfs filesystem defrag" causing 120s
timeout problem.

For btrfs_defrag_file() it will iterate all file extents if called from
defrag ioctl, thus it can take a long time.

There is no reason not to release the CPU during such a long operation.

Add cond_resched() after defragged one cluster.

CC: stable@vger.kernel.org # 5.16
Link: https://lore.kernel.org/linux-btrfs/10e51417-2203-f0a4-2021-86c8511cc367@gmx.com
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1603,6 +1603,7 @@ int btrfs_defrag_file(struct inode *inod
 			ret = 0;
 			break;
 		}
+		cond_resched();
 	}
 
 	if (ra_allocated)


