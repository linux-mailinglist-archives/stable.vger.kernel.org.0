Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C705F02BE
	for <lists+stable@lfdr.de>; Fri, 30 Sep 2022 04:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiI3C0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Sep 2022 22:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiI3C0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Sep 2022 22:26:32 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2054.outbound.protection.outlook.com [40.107.24.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3191191B3
        for <stable@vger.kernel.org>; Thu, 29 Sep 2022 19:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiyPH9GHAGeRdvx+k/YIpqJu2XY0obLbtRj6ssqBfNZQgRHgXjFbgEEf5wthoDt2iTKTDXpZYJMkx22YmoAeKIy1nPVxShbWCXSTX25Iex/de51LPvGZSLq9h8hQMtXCbh1txOJlVBPvjnnWm9pmYo+nAo5zE3Lh04lnh0ZhuuxommXczMO42hrqtMCZhpdF37UHBglMn5PBmC+hLPZE1Q6ysoO6zQ/QOgdn2t6Ghng3o157kYe9A+yNPgtQP8ZxaG2U0wX9FZTpR38lBigI6nGWysLRGYuiE6xJlxlNPAqPvSAWsHHzuMQl6H6z+uOk0kYzLKTV5MnGl1yovqZMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q51M2Q98u0A8JNp2aDlXlcnKTSkLK0VEVR6nPZrnXaI=;
 b=aRwgQuuYKF9BpvhTqGSQLLFBKp7SK9oFDjAGY9ouBSDpy2WF7mZHDPX0vWsINrDNLoqsfpW9Xl2ToruXPsc+hXeJUh69pIvDtekCCrocuoLMInaDJbQRfiAHczQdr+dN82D2PJGNvJ96z/vK3ooaqnIWvrHSlgueO5uMzP7Pffpa/iYTs73X5mLTwyNsLlAcDyWqXef8icXgGvHcHF7nPPg4ys3JWeFSWWjUJPhUHwTsgYmyWH6csDfQbUl2eDXlbZKg19LCZvjAToyyKW9stjCzzm0m11B7SF4S7ocRdHtk51yq5Ftd8o6suC/3zSOk0C2trUgsyFbuLanDb+wnHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 188.184.36.46) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cern.ch;
 dmarc=bestguesspass action=none header.from=cern.ch; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.onmicrosoft.com;
 s=selector2-cern-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q51M2Q98u0A8JNp2aDlXlcnKTSkLK0VEVR6nPZrnXaI=;
 b=S5WktgYxRkj3m5XNTikfJLejRCuIVEySfuA9UadtO4DOgZXSzDvf2O7TjlKzbgSh9dnisFHWJPxAaTjFy38eIypF7cyD+r+7sGFOuKiHEyf5NHjejiXt4TKksMCUL6ZOgC48MfeKd2YyJU7VOwWcBxytIzLaSGwHVZPYJV5zp1Y=
Received: from AS9PR06CA0483.eurprd06.prod.outlook.com (2603:10a6:20b:49b::8)
 by ZRAP278MB0048.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:13::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.19; Fri, 30 Sep
 2022 02:26:28 +0000
Received: from AM0EUR02FT040.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:49b:cafe::65) by AS9PR06CA0483.outlook.office365.com
 (2603:10a6:20b:49b::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23 via Frontend
 Transport; Fri, 30 Sep 2022 02:26:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 188.184.36.46)
 smtp.mailfrom=cern.ch; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=cern.ch;
Received-SPF: Pass (protection.outlook.com: domain of cern.ch designates
 188.184.36.46 as permitted sender) receiver=protection.outlook.com;
 client-ip=188.184.36.46; helo=cernmxgwlb4.cern.ch; pr=C
Received: from cernmxgwlb4.cern.ch (188.184.36.46) by
 AM0EUR02FT040.mail.protection.outlook.com (10.13.54.113) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5676.17 via Frontend Transport; Fri, 30 Sep 2022 02:26:28 +0000
Received: from cernfe04.cern.ch (188.184.36.41) by cernmxgwlb4.cern.ch
 (188.184.36.46) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep
 2022 04:26:27 +0200
Received: from [192.168.1.25] (24.61.185.63) by smtp.cern.ch (188.184.36.52)
 with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 30 Sep 2022 04:26:27
 +0200
Message-ID: <55905860-adf9-312c-69cc-491ac8ce1a8b@cern.ch>
Date:   Thu, 29 Sep 2022 22:26:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     <stable@vger.kernel.org>
CC:     <regressions@lists.linux.dev>
From:   Jerry Ling <jiling@cern.ch>
Subject: Regression on 5.19.12, display flickering on Framework laptop
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [24.61.185.63]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0EUR02FT040:EE_|ZRAP278MB0048:EE_
X-MS-Office365-Filtering-Correlation-Id: f37d3756-fb84-4bac-0bc2-08daa28b2e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WvGOtEYBh3D3F3cQ3TvdclD/RrxygXqp801ngZPDCgqJAGFiguSjnSaZsHfdThlNukNIuC68bhrJXbbjllCaCIVye+Q6KTycI34RvOIwvGg2ZBp7Bq8vQjRc7sPcKVh7YKXcaRBUhP1huCnrYyMKAg+MNr33t0jTmrQ83iosiqFa2TqA8tKHi4eMZJ1sE/uefVkupemRoWTzmOlp5lfcM4mZnCrwV44puipeotBl8HFdu811KTso82MzOuWmbQYORmnPgviCR4Uzcr0urpfVC/HXHW3/GSniZ+9wecCCjzGusEjFmEMe73R5UDkvcm0XaCJGsbGs0bO5b9vRTR+8Wf5pyXiAI93lZIOq9GRQNkm3mimWWBaR+NZpGoWiH+cNndlq+ZW/zMVg0t9RKtHuYbf1IADiUpIJjV0Akq3rRM2RCaVXq5m2+Vyin/oEMNrFV0ITgTMFwfvNAYXASbMPVwtzzzuZ0dApdUItrmGnq/HeeHtvK0bQ0TIVTvEyrh1g0EI/U3smIK8lW9N6iUoUgd1cUGdy2zjK5g3YNOH0ybmoGEdk+aPRlNqFYMr6gDUsxgvwjnb/75Bz1660DpiqaMVuEzZYQ3yZITtktIVh155xUOitrJmT84OQhbufN7umkFHhdkXkFdkUQ9Jh11hOZcsk6eqHrlXb6S9g2gryfdOiRmOmNJJsNiVYerlojWtSTRso1eg/McYEdb2wXfjioVSySsi0S8Uq3VD4WhgJCvjMNg4Xji13GaLORMtXJnJ2XqcTw/Ooh3h1K3bsLKUIKF41zIcEv5kQ1vhQ5XK8bXGD+7uljYlMmhkbpZN2+ry8QjEKye/kLccZfyORVjyZiQ==
X-Forefront-Antispam-Report: CIP:188.184.36.46;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cernmxgwlb4.cern.ch;PTR:cernmx13.cern.ch;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(36756003)(31686004)(31696002)(36860700001)(83380400001)(2616005)(16526019)(186003)(426003)(956004)(47076005)(82740400003)(356005)(336012)(7636003)(40460700003)(478600001)(966005)(40480700001)(26005)(8676002)(16576012)(6916009)(786003)(316002)(82310400005)(41320700001)(4326008)(41300700001)(5660300002)(4744005)(8936002)(70586007)(70206006)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: cern.ch
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 02:26:28.0794
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f37d3756-fb84-4bac-0bc2-08daa28b2e17
X-MS-Exchange-CrossTenant-Id: c80d3499-4a40-4a8c-986e-abce017d6b19
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=c80d3499-4a40-4a8c-986e-abce017d6b19;Ip=[188.184.36.46];Helo=[cernmxgwlb4.cern.ch]
X-MS-Exchange-CrossTenant-AuthSource: AM0EUR02FT040.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0048
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_PDS_OTHER_BAD_TLD autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

It has been reported by multiple users across a handful of distros that 
there seems to be regression on Framework laptop (which presumably is 
not that special in terms of mobo and display)

Ref: 
https://community.frame.work/t/psa-dont-upgrade-to-linux-kernel-5-19-12-arch1-1-on-arch-linux-gen-11-model/23171

Cheers,

Jerry

