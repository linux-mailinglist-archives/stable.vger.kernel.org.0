Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8507D4C6C19
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 13:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233969AbiB1MW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 07:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236243AbiB1MWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 07:22:55 -0500
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3279E70861
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 04:22:17 -0800 (PST)
Received: from [192.168.1.214] (dynamic-089-014-115-047.89.14.pool.telefonica.de [89.14.115.47])
        by linux.microsoft.com (Postfix) with ESMTPSA id 77F8D20B7188
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 04:22:16 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 77F8D20B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1646050936;
        bh=F2pA+MGBxLbhTll3QXUVgCB7sHXU0aNGiUcp1TC7KAM=;
        h=From:Subject:To:Date:From;
        b=EONyYDK8EHZfKh1xnzRE2Tgf0Thn9NTmI6NJCN5FE5DZBtT/iPvTBDfdGMBgx11ao
         l3zsYLwQf3urB15R6cxc+t/yjYxfUo+RoaXI+l80Ynde56GS7kbGQdxu1CKtIKgKv9
         Tn27N0XQLE1XOVkEeRizKI/n2xabuskaKwwXUqxY=
From:   =?UTF-8?B?S2FpIEzDvGtl?= <kailueke@linux.microsoft.com>
Subject: xfrm regression in 5.10.94
To:     stable@vger.kernel.org
Message-ID: <e2e9e487-1efb-783f-ca5b-7d0c88f8de7b@linux.microsoft.com>
Date:   Mon, 28 Feb 2022 13:22:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

in 5.10.94 these two xfrm changes cause userspace programs like Cilium to
suddenly fail (https://github.com/cilium/cilium/pull/18789):
- xfrm: interface with if_id 0 should return error
  8dce43919566f06e865f7e8949f5c10d8c2493f5
- xfrm: state and policy should fail if XFRMA_IF_ID 0
  68ac0f3810e76a853b5f7b90601a05c3048b8b54

I see that these changes are a reaction to
- xfrm: fix disable_xfrm sysctl when used on xfrm interfaces
  9f8550e4bd9d
but even if the "wrong" usage caused weird behavior I still wonder if it
was the right decision to do the changes as part of a bugfix update for an
LTS kernel.
What do you think about reverting the changes at least for 5.10?

Regards,
Kai

