Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD3F46BB82
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhLGMoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:44:18 -0500
Received: from mail-bn8nam08on2080.outbound.protection.outlook.com ([40.107.100.80]:35760
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236544AbhLGMoR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 07:44:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpkRzDDpaBdnudeWfwZuxLdYQKZv29nKahjQNQ035WFwx05qUU046UVoEqkL4bv3ncHJ5gcGljzQli9XKYuBSglzEh6SuFiQ8DR+RL0XY/eMxbvURKFq9Q27f994jmWxfTsEwYlLChvcNmzfKRtir3JAKf/fU4ApmDTRPLat2egbETEEDkqTLiA86aDnbmMm0u7WgV4+GQ/pZCjpz196T285FThds5XHLQ+mygaKHyLwWlDzkwjJQWbXHON482NSi8LzwEpzffAm5PzwM955cA8KbUVrkoc9R117lANQmgy8fWdG7icl+uFdPlHZmXf4juBtQ8voQKhECwR76pHLVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW8hvvY6N9ZQUhF8TIwBXv1J2p401JHaU2ZVVrGYMwc=;
 b=OY2mryE1AFbqDyhOMGMeqGXCXfHLDNhlyZkh0pBjP2Q7ZjZK5hvHHJ58gFvY9FbQHX0Kewu/dknsxifPrBrZEwmBFJnRM4LvUTKPnkNdaHc2WcUVpZFi8Y1GFhIhTkhvAB7RshGzBeJxWwKZuNFlPmkrKiu0ovz07VV17h2AUbuZE8/5cXsbjREFrXG47Ls1Jyp5bZ1uqynh416djsweVsFvsPtqsT4l62g9vIrJpHdJFyi/r1ymMW9eJdNtTTHxVnbomfkD2/vKTFqtAn3khAEENX8dy2EYYYw5OQcGbw7ZUCIaaVjC05yaR11gxWuJCtsTYqLoZLIiqOJfRsXMxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW8hvvY6N9ZQUhF8TIwBXv1J2p401JHaU2ZVVrGYMwc=;
 b=ayvJfzv8o0AIBLaEggayNXfyuJDXoe1X4nWjsFk7qZyhJXQUP5x5nsHuBjwGZJx7FzJ5Qqg0Se9okPbBO3SFjjxz1A95fiefGoZ9rWiL3eek5PYXN7ZBsyOkLE4MFdUBAYDEv9lMtpXOYKg3UhmxTtd5aVEPoFhcJKWYa8/k1AkP7YJEiOnSWsrtfiSk099bOfC/w+TcB8dIMMWrYBd7dCuYY7Owa2tnj9sDjQqZNJgo+nHk09JyjyeGmvPu3UmXezUqBs91eLS58PD3g5vb6aQ4ArEAuqucNLBxGR+OJYvUkT4tesDgIizjxL9Svks7Ahf4hZRC8oocsyexwtlaUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY4PR12MB1576.namprd12.prod.outlook.com (2603:10b6:910:10::9)
 by CY4PR1201MB0056.namprd12.prod.outlook.com (2603:10b6:910:1c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 12:40:39 +0000
Received: from CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b]) by CY4PR12MB1576.namprd12.prod.outlook.com
 ([fe80::24b0:46e7:d3c0:a77b%7]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 12:40:39 +0000
Subject: Re: [PATCH 1/3] ALSA: hda/tegra: Skip reset on BPMP devices
To:     Dmitry Osipenko <digetx@gmail.com>, tiwai@suse.com,
        broonie@kernel.org, lgirdwood@gmail.com, robh+dt@kernel.org,
        thierry.reding@gmail.com, perex@perex.cz
Cc:     jonathanh@nvidia.com, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mohan Kumar <mkumard@nvidia.com>
References: <1638858770-22594-1-git-send-email-spujar@nvidia.com>
 <1638858770-22594-2-git-send-email-spujar@nvidia.com>
 <7742adae-cdbe-a9ea-2cef-f63363298d73@gmail.com>
 <8fd704d9-43ce-e34a-a3c0-b48381ef0cd8@nvidia.com>
 <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
From:   Sameer Pujar <spujar@nvidia.com>
Message-ID: <4855e9c4-e4c2-528b-c9ad-2be7209dc62a@nvidia.com>
Date:   Tue, 7 Dec 2021 18:10:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <56bb43b6-8d72-b1de-4402-a2cb31707bd9@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-ClientProxiedBy: PN2PR01CA0006.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::11) To CY4PR12MB1576.namprd12.prod.outlook.com
 (2603:10b6:910:10::9)
MIME-Version: 1.0
Received: from [10.25.102.117] (202.164.25.5) by PN2PR01CA0006.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:25::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 12:40:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a9ea4ab-9bf7-4a9f-4942-08d9b97ec60d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0056:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0056FA470C9444FEC7A608ECA76E9@CY4PR1201MB0056.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MdgsCCf6eOXh87gAmi+3C4XuRkMg9TxxdZFd4OZY8HjJ0iB+i5nm3hYrCXz8TmlXnkuEdwx959IlzF4eee9Kic7LVwEJPfKsocft8uBV+qMiowcqxNC1ELTiDTya24unKPnzEQoRjqfRulEhW3qW2NOaLLvXbw8IzzmYPJGCPuAi3GGrGheWJvciOE762DNQ93EEoafWbtkBfo4ZZ20rRXMqvPcz3hIqK3Wv3PU+Gda4+z+Lv0mmhnNrDgpsxfcA80sYb8b0Dv9t/Kk2jOZYj2DljFawRhmMDt4WaHdSOKcxyiKr6Li0tPImrH4JxrQqVnzErexFbtnLjI2EiPJaJJmrxD5vzKV+QUv5rRWM2V2EhaJtFf5T0ZqWMzoPlm+5HGLHKEWt5336KwZVPR4aOKwgqCdHkwBPhxOU+XkeWqUhkqBBz2YMUztaTwzk9aoyr7HRFdh9HO4UqemhV9uo6Y//o/dj/4Da8jBjfa3h70M6CZ7pN25AI8OV49e3YFsBvzPvAAckkk4Vx5AswfsU4zXKh9vIRaS6Q0kfNbFncTSy+jLa+s32XNT/K+fw9QSp5xZ+D29ud7DiDSvJet54N4byeIM207T4kePOLfPSAztciX6/uqwTMwkp9TS5xA8iaf4Bfq5uAWtJPwrlHYDg8mFbngrvyQ6K2Qa9uH3KygGGIWhwmGbTEmbcmicBixFuB4DMptjd30cbrqaAji31M0ukxskGdpQuZ236mrFmu64=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1576.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6486002)(38100700002)(31696002)(8936002)(66476007)(66556008)(53546011)(956004)(5660300002)(2616005)(83380400001)(26005)(4326008)(86362001)(6666004)(16576012)(316002)(186003)(36756003)(107886003)(31686004)(508600001)(2906002)(8676002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEhZMXNGLy9tSVNPcHZKcFFnaEdOMjdqaUJpQkt0RWoydjZ1YjdYUEN4WjNC?=
 =?utf-8?B?TTNHVFBQUndnQ0plRXpLTVM4QTRjQVNHRCtKWTJrUStQMjE1NzV0QkZMTG1o?=
 =?utf-8?B?TmZVYkptT3pDS2IzbWlNMEdwM0J3Q1oxazNJekhnUVgwaWJoV3RKRjRrUDZs?=
 =?utf-8?B?WnZkVEJYWWJmajkwVFJHaWM3WUxLR3NVU2U5bmdsU0JOalNNTmpmaXJDZnpa?=
 =?utf-8?B?N2dnMXFRdERHRTBPbUt2NndLbG5YZms3aGN4L0t3Q3FoM1dnZ0NNTmREM20z?=
 =?utf-8?B?SnZEYkFxbE1VQk5sVjhCRE5lRXVvRUpzUG0zYy8yT3h6QnJnL29xV0dRSkhr?=
 =?utf-8?B?NFh3UnhwdElkdUZvOGpUREhMcUcwV005S1BreDJ4SWt3OEFibXZvcm5XbXBZ?=
 =?utf-8?B?RnlGZFhUbE96OWxCdnhYRlRHQTQ4TTdNNmNRTk9qVmpLM0hIdE9sUjZTTUdS?=
 =?utf-8?B?eUU3by9zT3RkaTJxMXlJTStUZm5lc3FxT0sxQjZCMWN5aUR3YVBISlVkd0ZR?=
 =?utf-8?B?RW0zazkxekh4SVd2dFFyZGdJeXFabitPSW9hVzM3cXVyTWs4K1NiekhNZ3pw?=
 =?utf-8?B?MFFPbk5yZi9DakloaTBjME8zT0FTUDU2bnFtWDhHSmZuaUZEd0RxZkxGYm9p?=
 =?utf-8?B?ZzlucFc0Zk5QZUVYTkFqRkNGMnRQNC90UG5GM3dmSXhtTVh4ME9TYUQreFFy?=
 =?utf-8?B?bUkwU3JremxWMEpLOThyOEZlSVBNTTNmeU03MVA5b1B3UWZwYjBWUUVLUEdD?=
 =?utf-8?B?WHB1SG1LaXpvN3QzdjkrODY5dzY0NG5iejNjUUtEY21VTU5kT1lVL0k1bnB0?=
 =?utf-8?B?U1IwTjRZQzRPU0NaUHlYUit2dHB0OTVBK3JTR1VMcWlyYzRIaG4wWlljQ2xC?=
 =?utf-8?B?cWNBRjVlbStZVVBLcllZSG8xcmlxS3dqVjUxVmhxQ29tSVBPNDRJRmRYQkdQ?=
 =?utf-8?B?K0VIY3dxdmhtNjJiMDJIUFJ0a1FtT1FTaVRqRDM3bCtvTHB2WG1aLzVITlM5?=
 =?utf-8?B?OVBEWll5VTFiYmk1NnZCQTZDSjNjOGlsbmQxbFhJR3ZDMXo0RlNZams0QVBo?=
 =?utf-8?B?MVJnZmpXZlVPTEVpR0dHaXQvT0lqNzZJbGd0K294SllsTkp2L3N0MXdNdDNN?=
 =?utf-8?B?TmZiTW03cVoyMGxudi9kenJ2Q09nTlM4cEdUaVdXN2tGZXdsbWxSaWRqRG9j?=
 =?utf-8?B?azU5blNYaEJUY2NqRkgyd3lKRWNxMzN5ZXd4Zis1bWJtRzNUNHMrdytva21G?=
 =?utf-8?B?cFh1SE90NExIdThMUjlqNG1pRGh3MGZCa1h6Y0hKME1NS3VOMkFRR2J5OGE5?=
 =?utf-8?B?c1pOa051cm5pS0p1Y1ZmaXRZaHY1MVljRDZYT2FOVjRVa3h6eDc1LzdncU5P?=
 =?utf-8?B?Umo1Wm5nK2JnN2UyZUhyQU41WTgvR2NPU3BwWjFLMkRiYWd2ZytRVHV5NEo3?=
 =?utf-8?B?cUNuN2QvUjU2NVNRRGltbWhUSThFVVdvU0N4VXlWdEt4RDROaWVLMXlnYnd3?=
 =?utf-8?B?ZFVUOUxHRFp1ZHVULys5R0JlZlRwWGowTHhPS01WcndpTnBWWUNhNmQvUnFU?=
 =?utf-8?B?WVFYSzBEWGZ3aU45RCtNNklrTGtaYUhBMzkycUZNWkJOaS96NXRIZmFyNlQ1?=
 =?utf-8?B?ZFJVQXVST245UzN5Rk1rOVpIUkJpWTJpbEt0OGZBcWd4ZHNWRnJYdHdRa3dY?=
 =?utf-8?B?bk5JQ1kvbEFOM0t4WXlTMW82TnpOV0ZMTVNoVDJTR1FLUEM2NWcvM0tMUEMy?=
 =?utf-8?B?azRjcW1IOW1VMmxQc2UwMkdzZndDc3RRY0N6NTFUazZNWGJnU3AwNUhKS2lI?=
 =?utf-8?B?SHRUc3pwRjBKYkJsR0xDMkZLVEtzSW8vWVNYSkdUd25VWU91ZXEwSkNVaFBJ?=
 =?utf-8?B?VkZ3b3dFWDBjU1IyZEplekMyejRIdXRqUFhTQ0FDTlFUWWlWOEpJb0lZV2JK?=
 =?utf-8?B?TkIzNGpRUHUyRTZiQS94dS8zUi95cVd2c1hZdUIzYy94eE1zMlZMMkxhU28v?=
 =?utf-8?B?emdBWXJyb3lUdkZuMlVhY1VRK3d1WXAyaWdETDdCMVF1OTJ6ZkM0bFlJNEpE?=
 =?utf-8?B?MFBoc3NNTlBHWkthSXhCUCtvdXhDYXBXZ2hiMFlMZkNsdUtZQ1hKYTN4QnFY?=
 =?utf-8?B?S0RaMzI4NW55dDVTRnhKTXp2NW5oNVh1Y0doNGdhekJmY1I2d05yZTFBY3E5?=
 =?utf-8?Q?g+IfFRGhC3WblyelOrmlRyw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9ea4ab-9bf7-4a9f-4942-08d9b97ec60d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1576.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:40:39.1022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sm+rGNHIHsIm5j1dRwpfdcbveUbt4ECLSR+mr2R/3ObHvQ0V4IP9MWl6eCUTE5+BKHe9c7oduUZfCOGr2qvDWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0056
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 12/7/2021 5:35 PM, Dmitry Osipenko wrote:
> External email: Use caution opening links or attachments
>
>
> 07.12.2021 15:00, Sameer Pujar пишет:
>>
>> On 12/7/2021 3:52 PM, Dmitry Osipenko wrote:
>>> 07.12.2021 09:32, Sameer Pujar пишет:
>>>> HDA regression is recently reported on Tegra194 based platforms.
>>>> This happens because "hda2codec_2x" reset does not really exist
>>>> in Tegra194 and it causes probe failure. All the HDA based audio
>>>> tests fail at the moment. This underlying issue is exposed by
>>>> commit c045ceb5a145 ("reset: tegra-bpmp: Handle errors in BPMP
>>>> response") which now checks return code of BPMP command response.
>>>>
>>>> The failure can be fixed by avoiding above reset in the driver,
>>>> but the explicit reset is not necessary for Tegra devices which
>>>> depend on BPMP. On such devices, BPMP ensures reset application
>>>> during unpowergate calls. Hence skip reset on these devices
>>>> which is applicable for Tegra186 and later.
>>> The power domain is shared with the display, AFAICS. The point of reset
>>> is to bring h/w into predictable state. It doesn't make sense to me to
>>> skip the reset.
>> Yes the power-domain is shared with display. As mentioned above,
>> explicit reset in driver is not really necessary since BPMP is already
>> doing it during unpowergate stage. So the h/w is already ensured to be
>> in a good state.
> If you'll reload the driver module, then h/w won't be reset.

How the reload case would be different? Can you please specify more 
details if you are referring to a particular scenario?
