Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804021F0FA7
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 22:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727080AbgFGUfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 16:35:51 -0400
Received: from mail5.windriver.com ([192.103.53.11]:34190 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgFGUfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 16:35:51 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 057KYtuZ007783
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Sun, 7 Jun 2020 13:35:05 -0700
Received: from yow-pgortmak-d1.corp.ad.wrs.com (128.224.56.57) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Sun, 7 Jun 2020 13:34:26 -0700
Received: by yow-pgortmak-d1.corp.ad.wrs.com (Postfix, from userid 1000)        id
 18F802E0451; Sun,  7 Jun 2020 16:34:25 -0400 (EDT)
Date:   Sun, 7 Jun 2020 16:34:25 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, Roi Dayan <roid@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Possible linux-stable mis-backport in ethernet/mellanox/mlx5
Message-ID: <20200607203425.GD23662@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I happened to notice this commit:

9ca415399dae - "net/mlx5: Annotate mutex destroy for root ns"

...was backported to 4.19 and 5.4 and v5.6 in linux-stable.

It patches del_sw_root_ns() - which only exists after v5.7-rc7 from:

6eb7a268a99b - "net/mlx5: Don't maintain a case of del_sw_func being
null"

which creates the one line del_sw_root_ns stub function around
kfree(node) by breaking it out of tree_put_node().

In the absense of del_sw_root_ns - the backport finds an identical one
line kfree stub fcn - named del_sw_prio from this earlier commit:

139ed6c6c46a - "net/mlx5: Fix steering memory leak"  [in v4.15-rc5]

and then puts the mutex_destroy() into that (wrong) function, instead of
putting it into tree_put_node where the root ns case used to be handled.

Paul.
