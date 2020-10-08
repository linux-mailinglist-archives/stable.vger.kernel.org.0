Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5232874AD
	for <lists+stable@lfdr.de>; Thu,  8 Oct 2020 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbgJHNAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Oct 2020 09:00:33 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42187 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730173AbgJHNAd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Oct 2020 09:00:33 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UBIzwIH_1602162022;
Received: from localhost(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0UBIzwIH_1602162022)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Oct 2020 21:00:28 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Wen Yang <wenyang@linux.alibaba.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Stable backport request for fixing the issue of not being able to create a new pid_ns
Date:   Thu,  8 Oct 2020 21:00:21 +0800
Message-Id: <20201008130021.79829-1-wenyang@linux.alibaba.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After the process exits, the following three dentries still refer to the pid:
/proc/<pid>
/proc/<pid>/ns
/proc/<pid>/ns/pid

https://bugzilla.kernel.org/show_bug.cgi?id=208613

According to the commit f333c700c610 ("pidns: Add a limit on the number of
pid namespaces"), if the pid cannot be released, it may result in the
inability to create a new pid_ns.

Please backport the following patches to the kernel stable trees (from 4.9.y
to 5.6.y):
7bc3e6e55acf ("proc: Use a list of inodes to flush from proc")
26dbc60f385f ("proc: Generalize proc_sys_prune_dcache into proc_prune_siblings_dcache")
f90f3cafe8d5 ("proc: Use d_invalidate in proc_prune_siblings_dcache")

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
