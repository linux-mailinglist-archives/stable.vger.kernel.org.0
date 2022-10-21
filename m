Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E3C6070E0
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 09:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiJUHWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 03:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiJUHWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 03:22:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4704B245EB6;
        Fri, 21 Oct 2022 00:22:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eA/V9y7t8ILJg2TLWXjNkqwtFmKILH+BEliY6uj0w4SGvJLSDshIsMcy7Y4s87r0lFR3i57KTbuOcgTEA2fdupCfJmUdDcm7PRNJvKp9EoZ0j7jB4TOfkOrTrYgLCV3912VnVojsEf581uWtUy8lABlLWXToZj7ZXk1bNdgrGbBiDgpmQL8R1iHYA9ypoLGOqOaLxqMvqXbeyULceED5tGLAPJhb/T6qg90XNBo8eMvnJkXcPdW+eU0aSAfaAZYT3+zqduXnJgRaJ9Zx8+D8Tu66HpBhLVy/A+21KvjEHSueTeXIYtJl5fFnE4lgJD+I5Z7ml+IkO2IBawP+o5Mymw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4SBe+bvO9rqwXRLYXMZeJacmY3qcaIu13dFi/JDQGw=;
 b=I7R5gNe1gNwdEzpIZJnLXXM0+8eTc3rEDjOYC5e3tJ4ZitkvmK4jzRqDCaMTYudfMo+XmeyQxvceEZZBiUhPYR3C0c6EdsMaZnqZXGL7SNDufuUuTemC2WN6JbOjTJRJSGz8fr019n03j1bF5qTHmFkRtOrUVIYKFX3bRPoty0xXkocGKDroHmGiXLKLpPWeCUi5rh04sWhNX9skWgFk1EW6dWqAVS0O87OrSaO1GIuCZZornr5f8y9tvGkw/jcRYBJY0r4XLah1KANE/J84CI3kBMqOXbXTdeIBo8jHLdInjjPGgyg/yNi7iXutdWQnPqosOvXnS+BzlC8Jo0eeCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4SBe+bvO9rqwXRLYXMZeJacmY3qcaIu13dFi/JDQGw=;
 b=z91on0AeKP1vxxyKn5Cz49V4kRAR5+HR2p69uRiC3Sn9ZPCGV3AegOgfLmspaZEua4S5QbCkI0rD4OwTzhRNXHp5hrZUhxOasaZZ385ED0NoDsVVXdeR62o/MChkM5vHcHvbRfEObbghYnxrW9HphKMO99kF7A/TEQmDhMRhHjc=
Received: from MW3PR06CA0017.namprd06.prod.outlook.com (2603:10b6:303:2a::22)
 by CH0PR12MB5185.namprd12.prod.outlook.com (2603:10b6:610:b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Fri, 21 Oct
 2022 07:22:05 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:2a:cafe::a1) by MW3PR06CA0017.outlook.office365.com
 (2603:10b6:303:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33 via Frontend
 Transport; Fri, 21 Oct 2022 07:22:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5746.16 via Frontend Transport; Fri, 21 Oct 2022 07:22:04 +0000
Received: from [10.254.241.52] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 21 Oct
 2022 02:21:59 -0500
Message-ID: <7383e705-6b8a-9e3e-ee94-6c59d8173779@amd.com>
Date:   Fri, 21 Oct 2022 09:21:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v2 2/2] Revert "dt-bindings: pinctrl-zynqmp: Add
 output-enable configuration"
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <saikrishna12468@gmail.com>, <git@amd.com>,
        <stable@vger.kernel.org>
References: <20221017130303.21746-1-sai.krishna.potthuri@amd.com>
 <20221017130303.21746-3-sai.krishna.potthuri@amd.com>
 <20221021011125.GA2104528-robh@kernel.org>
From:   Michal Simek <michal.simek@amd.com>
In-Reply-To: <20221021011125.GA2104528-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|CH0PR12MB5185:EE_
X-MS-Office365-Filtering-Correlation-Id: 561a32e8-c510-4598-0f3c-08dab334f49d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rAwI2oKME07/Y/lrrzu14GGUs5a4lndntHiMSOi2hZqVyg6pDHFfDeSLYfxGlXPeL0Feuy+KzB76UrTThrfHAMDZu6gReQhKNHohIAMHFXqbQOwGr1ihiSJ5X3673x5llmREoTzy7zXLQtQcz5aYy2Xp2r+2nQu2mTEN1by3gtxE7s5J8cgJad+JCr9+edEozRQqz7UgHBPXvBbDWxbI74qImpbMh2KOwHAtdvNto5cxH62I3lTVSrSlbJobgq9KU5zD+8L8QT5hTTpMQ6TjY844gIUSbS+sC+LXLXCUkyFDWVHA0MDzFq9eIntQDJ6TtTHgPl4C4tDZqLu4bljRIB6I+op0ijz33OKwg9UdAQ1tdHDD0GjIEdvZTvaMh1khvLxvNDZX51MkwrkdvyW1lDFXX1AxD+q3T55E8e/ZmBNNWpmgFxQSE0nqo2ccv5HWBC08owBjoxjvrC4UbVjHYkyDtn0cCnch3LHTogbvsL3ckCw7F55BYhMwxNplZJAxRWuzKj8vYDOy4jtA5DD7MKO8CBEjgISt8THhVqEeH2N2aygJaOzAiKBKKyDukX0Jn3VW+UbQ0RGXIwGF7Ap7HzA94ax5f0OtnzFU+PdVZ4CqjLOjGR7KeitibPmcXTr7sLHjqP9WKmFsPLCzUOriPhE/RyuMY9H1haxq+nGpTHbuqnLCrESHBmWYjep9rMnXEY4NdYzpCc57ur+Iy2wLitpG5ke2uIQTKSjaz7Uyox1F+8elTRHN9aSm9GAssZsrFEllrhnA8szr9ikgAhWiMIZu+lmzsqO/GNH+pc3HfvnytaFn+M2+rfwtMRiJL8N9kGm1zA3FvtP63gahLaMKxw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(31686004)(36756003)(82310400005)(86362001)(82740400003)(356005)(41300700001)(31696002)(426003)(36860700001)(53546011)(40460700003)(336012)(47076005)(83380400001)(2616005)(81166007)(16526019)(186003)(5660300002)(40480700001)(6666004)(478600001)(2906002)(6636002)(16576012)(316002)(70206006)(8936002)(8676002)(4326008)(44832011)(4744005)(26005)(110136005)(70586007)(54906003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 07:22:04.8232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 561a32e8-c510-4598-0f3c-08dab334f49d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5185
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rob,

On 10/21/22 03:11, Rob Herring wrote:
> On Mon, Oct 17, 2022 at 06:33:03PM +0530, Sai Krishna Potthuri wrote:
>> This reverts commit 133ad0d9af99bdca90705dadd8d31c20bfc9919f.
>>
>> On systems with older PMUFW (Xilinx ZynqMP Platform Management Firmware)
>> using these pinctrl properties can cause system hang because there is
>> missing feature autodetection.
>> When this feature is implemented, support for these two properties should
>> bring back.
> 
> So I'm going to get to review the revert of the revert at some point?
> Why do the properties need to be removed from the binding? They work on
> 'not older' firmware, right? Isn't just removing the driver support or
> removing from .dts files enough?

Removing functionality should be IMHO enough. Maybe make sense to inform users 
that there is missing functionality where they define these properties via DT.

Thanks,
Michal
