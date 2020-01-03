Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ABB12F95E
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 15:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgACOyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 09:54:47 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:51777
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725890AbgACOyq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 09:54:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zrgi8odqYiHRVYdXoE8Mf+hJ1uIKAIUJj1juC7tg0zjerjyiAdGPEXbxgamqBrzfvW1NjuWRGJG467dw1e8BcGcCRtyEbuZXsxAf2rg5smbFV5KqcMOjJAx637uImDWdPF6v1nQsrvP47DNqZFxIMnkuzRaOkNLRnPf69zxz0amo6bz/zbKQhMm/JLN2+1Hm+F2U1KA3WrHCgWTPA8/MDzYxuyljr1XsoMV+t6vIYe3fFHLgrcijSW82/FTEYikGYy4egxrY9vHAZHeoE+eBIc9GWLtCe2BFWGOF5d3SkxFIb+t4RVfnH5TYN1GZrBEfqkH2Sl+70TzH3iZko8ivmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdNqP+XNtXGqNj1Vs/26aABK04E1TSgI+Ui1YzZ7suk=;
 b=UcTI5a2eJoMnLVtu8SLknyPT6WD4SqjxShYcu35Qxg7Fbs7sddPnkKDUwfcGkP9L6XANEuFBXJirugjGl2ga9BhMj5eDbkDyZUEz30UAR4VafiYZWPLVQZvX0slAZLHkDvfTz8lMhULVylTbasB0eBAn62/ZATSf+3x2Qs1qEDCKEZUx6cETN11E10ZBbtV0kxGOvCOvEQk9RExRyskX3JbiC2UFwYMCNYZ3yy+VAcb1uW1nEgdi6EYevHa9VqF2x22ZLsvpz7rjZ/W4/yWD12kI0HMlmmf9Wdw+raC+FNqMCuQ5aQVjJA1/jx/c8noTKQQBracL7Bm+qkA3Eq24YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdNqP+XNtXGqNj1Vs/26aABK04E1TSgI+Ui1YzZ7suk=;
 b=pV/dG/AvBuWwYdGGH7SvACdKEPILnCEpN0Gsf7S6DO2IhRl5sAEfTVHmTSvg00pk7YKB0OuAnK2my5xvwSJVt3IR31uPrLAdfVzOT2tNIp4SlYRG1GVYP88vx1hRy2q2WReTskzHiArFQRhCPH60oH8NAcVonM2Uhay0z13kuIo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Harry.Wentland@amd.com; 
Received: from CY4PR1201MB0230.namprd12.prod.outlook.com (10.172.79.7) by
 CY4PR1201MB0134.namprd12.prod.outlook.com (10.172.77.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Fri, 3 Jan 2020 14:54:42 +0000
Received: from CY4PR1201MB0230.namprd12.prod.outlook.com
 ([fe80::301e:b0c8:7af:d77d]) by CY4PR1201MB0230.namprd12.prod.outlook.com
 ([fe80::301e:b0c8:7af:d77d%11]) with mapi id 15.20.2581.014; Fri, 3 Jan 2020
 14:54:42 +0000
Subject: Re: [PATCH v2] drm/dp_mst: correct the shifting in DP_REMOTE_I2C_READ
To:     Wayne Lin <Wayne.Lin@amd.com>, dri-devel@lists.freedesktop.org,
        amd-gfx@lists.freedesktop.org
Cc:     lyude@redhat.com, Nicholas.Kazlauskas@amd.com,
        harry.wentland@amd.com, jerry.zuo@amd.com, stable@vger.kernel.org
References: <20200103055001.10287-1-Wayne.Lin@amd.com>
From:   Harry Wentland <hwentlan@amd.com>
Autocrypt: addr=hwentlan@amd.com; keydata=
 mQENBFhb4C8BCADhHHUNoBQ7K7LupCP0FsUb443Vuqq+dH0uo4A3lnPkMF6FJmGcJ9Sbx1C6
 cd4PbVAaTFZUEmjqfpm+wCRBe11eF55hW3GJ273wvfH69Q/zmAxwO8yk+i5ZWWl8Hns5h69K
 D9QURHLpXxrcwnfHFah0DwV23TrD1KGB7vowCZyJOw93U/GzAlXKESy0FM7ZOYIJH83X7qhh
 Q9KX94iTEYTeH86Wy8hwHtqM6ySviwEz0g+UegpG8ebbz0w3b5QmdKCAg+eZTmBekP5o77YE
 BKqR+Miiwo9+tzm2N5GiF9HDeI2pVe/egOLa5UcmsgdF4Y5FKoMnBbAHNaA6Fev8PHlNABEB
 AAG0J0hhcnJ5IFdlbnRsYW5kIDxoYXJyeS53ZW50bGFuZEBhbWQuY29tPokBNwQTAQgAIQUC
 WFvgLwIbAwULCQgHAgYVCAkKCwIEFgIDAQIeAQIXgAAKCRAtWBXJjBS24xUlCAC9MqAlIbZO
 /a37s41h+MQ+D20C6/hVErWO+RA06nA+jFDPUWrDJKYdn6EDQWdLY3ATeAq3X8GIeOTXGrPD
 b2OXD6kOViW/RNvlXdrIsnIDacdr39aoAlY1b+bhTzZVz4pto4l+K1PZb5jlMgTk/ks9HesL
 RfYVq5wOy3qIpocdjdlXnSUKn0WOkGBBd8Nv3o0OI18tiJ1S/QwLBBfZoVvfGinoB2p4j/wO
 kJxpi3F9TaOtLGcdrgfghg31Fb48DP+6kodZ4ircerp4hyAp0U2iKtsrQ/sVWR4mbe3eTfcn
 YjBxGd2JOVdNQZa2VTNf9GshIDMD8IIQK6jN0LfY8Py2uQENBFhb4C8BCAC/0KWY3pIbU2cy
 i7GMj3gqB6h0jGqRuMpMRoSNDoAUIuSh17w+bawuOF6XZPdK3D4lC9cOXMwP3aP9tTJOori2
 8vMH8KW9jp9lAYnGWYhSqLdjzIACquMqi96EBtawJDct1e9pVgp+d4JXHlgIrl11ITJo8rCP
 dEqjro2bCBWxijsIncdCzMjf57+nR7u86SBtGSFcXKapS7YJeWcvM6MzFYgIkxHxxBDvBBvm
 U2/mAXiL72kwmlV1BNrabQxX2UnIb3xt3UovYJehrnDUMdYjxJgSPRBx27wQ/D05xAlhkmmL
 FJ01ZYc412CRCC6gjgFPfUi2y7YJTrQHS79WSyANABEBAAGJAR8EGAEIAAkFAlhb4C8CGwwA
 CgkQLVgVyYwUtuM72Qf+J6JOQ/27pWf5Ulde9GS0BigA1kV9CNfIq396TgvQzeyixHMvgPdq
 Z36x89zZi0otjMZv6ypIdEg5co1Bvz0wFaKbCiNbTjpnA1VAbQVLSFjCZLQiu0vc+BZ1yKDV
 T5ASJ97G4XvQNO+XXGY55MrmhoNqMaeIa/3Jas54fPVd5olcnUAyDty29/VWXNllUq38iBCX
 /0tTF7oav1lzPGfeW2c6B700FFZMTR4YBVSGE8jPIzu2Fj0E8EkDmsgS+nibqSvWXfo1v231
 410h35CjbYDlYQO7Z1YD7asqbaOnF0As+rckyRMweQ9CxZn5+YBijtPJA3x5ldbCfQ9rWiTu XQ==
Message-ID: <854f57f3-b8b4-284f-796a-1c6d4f487471@amd.com>
Date:   Fri, 3 Jan 2020 09:54:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
In-Reply-To: <20200103055001.10287-1-Wayne.Lin@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YTXPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:1::39) To CY4PR1201MB0230.namprd12.prod.outlook.com
 (2603:10b6:910:1e::7)
MIME-Version: 1.0
Received: from [172.29.18.152] (165.204.55.250) by YTXPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:1::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.11 via Frontend Transport; Fri, 3 Jan 2020 14:54:41 +0000
X-Originating-IP: [165.204.55.250]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa16acd3-1654-44ad-5922-08d7905cdd6b
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0134:|CY4PR1201MB0134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01345C0A1CA661A2F6C47B3F8C230@CY4PR1201MB0134.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-Forefront-PRVS: 0271483E06
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(199004)(189003)(16526019)(186003)(316002)(31696002)(31686004)(8936002)(8676002)(5660300002)(4326008)(53546011)(956004)(26005)(478600001)(2616005)(36756003)(2906002)(52116002)(81166006)(81156014)(6486002)(66946007)(66556008)(66476007)(16576012)(70780200001);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR1201MB0134;H:CY4PR1201MB0230.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ke8gXGmFjiqlQXeLt2B7wpxu5QXz/liSoyiqCeNCpJCrl+Xj8nftVMyvMEPEGaQrGCxdyEhLK/KUbQqi0Bs/fdGkXLMowNYiHrVYI3xbYvY9CEyyqPnnWGrIDNYwBpT1lDBiTXeSkvjPYFSTyjvRSUUF7+cglkx1EgzsZJ/DQmxiSgujBOQUhQyltew/DOKTDKv7N22PID0XAfylHBP03bAma9BqGClM0JYlhwEXmrJv5+wsx5Hg8Ee4CcHd03me7h56xZvHNiuq27+eB3cz+5dsTZcvBMyE4EdlDosHF7ZmLL/RVOqflMgc3oKlXLApEjmdfMapSgg+HWCM2pIWr1bHk+uWDndihBZkyCnfQ3SJj/NLgQCt/GqSWgWy547ft/0C0vVF49nUvuW95MLshrcWXVhCYUDFQO3jxnoqtJ47q+2HBtdjUDvnonv8ekvxRZSY0VC1CQ6U5eZF5QDc6rEokt4aGAjFCsKUdlXYI8TjmatasCe+B+GT3F1TiFUK1YWWSSCgqIIiVF+NevrxCZ1U+iZ+Pkj2Bl4msuMttMA=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa16acd3-1654-44ad-5922-08d7905cdd6b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2020 14:54:42.7533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eb8om3qZQLcHzB0An7wMyvMNDP+0uHIp+h/m2XpE/jRF5h/ka056ULDKu5uH3rRvVz3SaOuP1indyKibjW54Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0134
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2020-01-03 12:50 a.m., Wayne Lin wrote:
> [Why]
> According to DP spec, it should shift left 4 digits for NO_STOP_BIT
> in REMOTE_I2C_READ message. Not 5 digits.
> 
> In current code, NO_STOP_BIT is always set to zero which means I2C
> master is always generating a I2C stop at the end of each I2C write
> transaction while handling REMOTE_I2C_READ sideband message. This issue
> might have the generated I2C signal not meeting the requirement. Take
> random read in I2C for instance, I2C master should generate a repeat
> start to start to read data after writing the read address. This issue
> will cause the I2C master to generate a stop-start rather than a
> re-start which is not expected in I2C random read.
> 

Thanks for elaborating on the potential consequences of this bug.

Harry

> [How]
> Correct the shifting value of NO_STOP_BIT for DP_REMOTE_I2C_READ case in
> drm_dp_encode_sideband_req().
> 
> Changes since v1:(https://patchwork.kernel.org/patch/11312667/)
> * Add more descriptions in commit and cc to stable
> 
> Fixes: ad7f8a1f9ce (drm/helper: add Displayport multi-stream helper (v0.6))
> Reviewed-by: Harry Wentland <harry.wentland@amd.com>
> Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
> index 1cf5f8b8bbb8..9d24c98bece1 100644
> --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> @@ -393,7 +393,7 @@ drm_dp_encode_sideband_req(const struct drm_dp_sideband_msg_req_body *req,
>  			memcpy(&buf[idx], req->u.i2c_read.transactions[i].bytes, req->u.i2c_read.transactions[i].num_bytes);
>  			idx += req->u.i2c_read.transactions[i].num_bytes;
>  
> -			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 5;
> +			buf[idx] = (req->u.i2c_read.transactions[i].no_stop_bit & 0x1) << 4;
>  			buf[idx] |= (req->u.i2c_read.transactions[i].i2c_transaction_delay & 0xf);
>  			idx++;
>  		}
> 
