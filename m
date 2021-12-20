Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7947A9BF
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 13:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230399AbhLTMfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 07:35:03 -0500
Received: from mail-ve1eur03lp2054.outbound.protection.outlook.com ([104.47.9.54]:21223
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230289AbhLTMfC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Dec 2021 07:35:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juBB9He4jWtMVa2gfhd9No+05r03igVHlrInfSAdwz8RuhqSd2wxit2GRnx8KAj38yQ5qaHZls6wsZwCvBve3PusVlDE+6TWm6iC6J3ldNy4dCbNoRIm+IEt4sSWXZ69AT/rbBz3WoFPTGv6dWeUW51mxA94bFV6DOjVXdoL1U7Jh3nXYhwXouQukGlxRqG5fIESqWkDYtRmO2nfGDvFnnC0ERzPhFU0EyCmi56iQc34PVO6dkWg2ERl2njoqHbbrKiWUVfWdb/PHrVZWHidJh8BWuaTK8zqsUG3iZONNVpKMEJ1ssstZb8PiUbkGqp8Tzo1DvNf5VidowbU2kpwwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDmcrssxN2luPlq9mPwZJeiOPhAHuH778wTR8fur8iY=;
 b=dEy53gIaoJ6X6Gc0MXR75sPaegSMk7zqCvCauBdkxjCv299wKEVFd2ecoqL3pF8xBi4ur1nFMsIuhUcM/4iP7heNoExyLELxcFg6nXxIt7R7ysLiru4J4Zsj7qqxCCWtHmnaNSxUCWHsDqIQ8GY/zm8qPuWU59PR98T3giOmjtLd9cgXPNayeeIDBf5fvNpacuDfLxomp+Pug5RjljoDdSj52ZczeoWgrQDYqKbH6dcgYrNpKN1ZSXG9QhFesDi5ousk8wpyOW7bJYNKlPnuNOogtfDyEje/85fjQTEh/Vyh+MymZW0d1ZcC5dlOHDNmpks49mu2UX20SuoVwj3uoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MDmcrssxN2luPlq9mPwZJeiOPhAHuH778wTR8fur8iY=;
 b=eRUHVblRt0PsYtAC+tfXm+677+J1A9HAVqvLANdhEbbnNSHujlll8F9/sISVBc/m6/Kp8vkZLK+9Z/jckShZ4FQ/ZP31pz/cEIgFcX3aZhyklVSoj/OEmbOJ9C1hifksyvdTSptfSw41cdMSYBERrkCgSOqpRmhJ0J4qodrUDmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by PA4PR07MB7485.eurprd07.prod.outlook.com (2603:10a6:102:c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Mon, 20 Dec
 2021 12:35:00 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::4515:de1:dc1f:db8f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::4515:de1:dc1f:db8f%4]) with mapi id 15.20.4823.014; Mon, 20 Dec 2021
 12:35:00 +0000
Message-ID: <ac686ed2-2638-3e77-4a4d-b5b0387ff9ff@nokia.com>
Date:   Mon, 20 Dec 2021 13:34:56 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2] mtd: spi-nor: Check for zero erase size in
 spi_nor_find_best_erase_type()
Content-Language: en-US
To:     Tudor.Ambarus@microchip.com, linux-mtd@lists.infradead.org
Cc:     p.yadav@ti.com, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20211119081412.29732-1-alexander.sverdlin@nokia.com>
 <0cabce03-bc22-eb3d-fa77-a1f5f787784d@microchip.com>
 <08d6657c-afa9-8739-196b-1e66d802e614@nokia.com>
 <88db4d69-e983-a359-ad50-9981e465b1fa@microchip.com>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
In-Reply-To: <88db4d69-e983-a359-ad50-9981e465b1fa@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0701CA0021.eurprd07.prod.outlook.com
 (2603:10a6:203:51::31) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 73f000c3-881e-4bd5-093f-08d9c3b5232b
X-MS-TrafficTypeDiagnostic: PA4PR07MB7485:EE_
X-Microsoft-Antispam-PRVS: <PA4PR07MB7485168610AA837C7503F3F9887B9@PA4PR07MB7485.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KV9/jx8B92QcBvtWCO2M9WDYz44futDEl+USVlDB4m+OTAlTkpXv0GPcV0t0h6fE+pMp7bGo4q19w9XUCkH0ea7WcuMivMweEf1n1EGAI49ixGyektO9kQrulLYyLevRmGV8D1p/Oxhef3fx3tywUSJSXHRyEiX0W0uSrYHkwu6Gc7bfDuVtvtKJ1ZdY282TzblZoGkktSYY+RbBxP3fQKjHCCOg2ynoeLmgSVQxTHGrw8Ow+9kL7SRlA7wmzgBi2r0lsqgBYz6/IaV96BxG4ZJvt6Erdw8RlFddtN3+IL1v3J52kWTbNOqXOdteYgPnhsI3btX7hzgeRdeowNvjenvWI62eUd+pIQbJE+RigussMDQXYN2awlJm9tBHFDfgv2TbXTiuT6fCPVhpWyDeL4eWwSUpSXbFQzpVaaHIaUw0kVCkNSnNEn/U/FnZebWB+pL/hzI9Pb4tApwB6V8yGQRYH6GJRlnl8pmNT6knFCeKIX4tt+qx0Wg0snYK4q/F9t3UaDhxyGGf1j0Ab9PNi+DUEYxZr9LDeDGc2Fz3HJqK9R7e2i66vrU43I/LASHluLmv1e8vN+C2dL1WzHnLRUESoZLlh82Gig3GzP63J+MWsjnpkMEaQlbWF1rXgWC/E7hFsJuWpvsRhMqu4g+hUl1YTR4CrKC3EMGOx3P/DAwCSkAZkN1Tx2n4rA/Dow9qCoqxfWBIfO9Ognd5HwyrRjcDxjNrU/+IwY3RJSHp0IQuK6r5HUQvEui8DbA+Cjk7axZhrlM04rIPP7gOdiLA4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(31686004)(38100700002)(6666004)(316002)(66946007)(36756003)(66476007)(66556008)(8936002)(4744005)(44832011)(8676002)(5660300002)(4326008)(38350700002)(2906002)(82960400001)(186003)(26005)(53546011)(508600001)(52116002)(2616005)(31696002)(83380400001)(6486002)(86362001)(6506007)(43740500002)(45980500001)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkgyOFZPcldPQ0oxSU5sREdrQTg4cjZLOXRVUVJxaER5Qld2M0dxc1liRzBi?=
 =?utf-8?B?WUxsd0hGUC9xZUp3eERRK0FQMENaMENUMXNOc2xWU2d5TW9iNTRTN2lxUkZ2?=
 =?utf-8?B?dWsrRi9JekdTYU5wUlNaeVo4bWpIM3lkZFYxVnE5R0dtWnAzMEN3d2dnTzln?=
 =?utf-8?B?bzQxMDczSjJoemVJVkNSYU03R0xKVGs3dFcycWFzMFJTRG5QSmlZMHdBT00z?=
 =?utf-8?B?WkZnZ3BmazNKZ3R1R3dPMmxLcm9XczNqY2hFRTIvY0E0aUJsN2hia1MzZk1G?=
 =?utf-8?B?WDkzYlJKQUlucUhEa0pETitiSmFzZUZHL0JRQjVUc3RTdWxnWXY3WE5DUlZ5?=
 =?utf-8?B?S1NFNS9pT1AvVHBSbnJxOE9aZC9CcHZoMEpkWDJOd0JxWFc0cXlQUTRmWldr?=
 =?utf-8?B?VkxWRmpnWWtQa2VieEFmU29KNHY5eXdpNEhKaU8wVnovek4xQ2VVQXVDUTRE?=
 =?utf-8?B?MkZjS1dpSWUyKzZKUG0wZHQ5S1ErZUdhN09acGpHSjZGVzI5TnVPbDdOeXZ5?=
 =?utf-8?B?d2xwL1RsZnJqeXdpVU5rQ0dpZUV4blRRRm9mRVNqUFVqZXhrcXozbHVIbUxI?=
 =?utf-8?B?RWZ0d0pGOXBIWHlQcDMyTDhPdWwvV3EzejNKRG1lNVZZZGlORjE4Z1RmYkkr?=
 =?utf-8?B?YllMM1Z1SUNIbXFiaVR4bDhDV2ViQ3ZvRk1DQUVEb1dUd0I3NkFHQUJ5Q0Z5?=
 =?utf-8?B?TklhQk9saThiblpzRFpPTk5QaHdUbklidkFKT1JxVXdVdXRIK29KdlU5RTBy?=
 =?utf-8?B?T2l1a1RoSlJhOFZuN3I4M1RIZFBGNGYrdVFvU3V4Nk1CUlVscDh3aDhldkFE?=
 =?utf-8?B?NS9LdzJVQmx4MjVEVjZHY2ZkT1FvOXJwOWpOaHhnb25CVUl2bVdONml2NTlk?=
 =?utf-8?B?cjdvb1BEcHlxaU9mN2xkRk9YZldOdHVaeENnL2FHRERnU0RZOUFyR0JlYUtz?=
 =?utf-8?B?dkxkUTdNcEVES2ptSkh4NkszSVJnbWZnbVNDN1d3QnBYeDg1ekxpb2dHSzYy?=
 =?utf-8?B?V2VZM3Z5SWtqUGpBblBGQTN3ZDJMRGJLN1h6akdLK1JvNXUxdnU5QURZbFRr?=
 =?utf-8?B?blJ4dzF1d0UzbDZKWk10ZEljYVhHK2hOa1JXNmtZaFFIanZqdEpLUThKUkVZ?=
 =?utf-8?B?ejFpTnpEeGhzeTVhYXlzUnpGN2lRL0tIaHIzR1VZYXJBdmJHLy9RdVlxOXI3?=
 =?utf-8?B?ZXNVKzNncWwwNEtKRWE2WFJRakFTNjlmYnRmMVVKNk1ydWFjdXA3SnZ4MW9s?=
 =?utf-8?B?SWxZU051cFRCbkJaSFdiZFdNd2VsZkJUV3FLSXRYb2cxK0k3NmU2aWp0akpm?=
 =?utf-8?B?dWtjQzMrUnZzblZiQVNWM3lLZUVmWlFKNXRxY2Z5UGlRYVBCTnQ4UWtFcWE1?=
 =?utf-8?B?OWU0bG1VZVpyQXQveDE2MnJEb2doeTFtR0NHa1lubmZWRTNQNTZJT1c4Y2ZT?=
 =?utf-8?B?R0JzQWYvVVo1blRUclhvUHZMOU9Eck1wRlFiaXNuaDRvSEt6ZlNMWnFUSE16?=
 =?utf-8?B?aGE3VEdvbjR6TWNxS1hUck52RnlnVnZhKzMzZkdYMnZYMWZWVklMSncrTTh4?=
 =?utf-8?B?WVE4WFc5M1RqZ1hnTFVjQ3E2MzZ0VWt1MjdaenphNWJWY1VWclA1UXZKbDZo?=
 =?utf-8?B?K3B1SFJuOXl1NXV1bVlsUjZLeEFucEhIV2RZeVY3Y2IyWEVQbGt1YlRwSzJt?=
 =?utf-8?B?bVF0ditKZmlVZG5lUjEwanFHVFdIMExkaFJtNTF4bkxndFQ1MFNrQTExVGNF?=
 =?utf-8?B?aldqaWM0ZVFobENSS2lvR05qdGtPblJlN0psYkRxZisrKzBJQzdtNXRVOUxE?=
 =?utf-8?B?M2lWWDN2MmJsVEdqTUo3WEVmeWJPc0o3L0ExSlNBdGNCMHJ3Nk9tNUZsdTJh?=
 =?utf-8?B?UXhiamdNNHhQNDRZTFFpanpmWDQ1bHJiNE1QRnNBWTlGUnJOdUEvT0s4Q2Vj?=
 =?utf-8?B?VGt0V0NheEE1eXpHVHJpKy8vcmoyN1Z6d0ZUWllSeXpiUXNXUnl1WllHeXZQ?=
 =?utf-8?B?UUhQd0gwOWZ1TlZhRmF3aytQenl5ZkNibVJUVC8zZjFQY1RGbWYzQ1RjMThs?=
 =?utf-8?B?TTU3VThwNlRDQStaYWVmVzh0UlVTc1JwdDArOSt6dm5lbFVaY1R1V2NUd0sy?=
 =?utf-8?B?SWk4NEpsTVJydVRMNU5hWlVIRE8rTEJ0cUlFWk9pelM3ZGhkTkJPU3I4M2U0?=
 =?utf-8?B?K05jRHlqZ3B4aGtzWDdGRldDejBKWk03ZXBVenAvVEFtNmhpRFhrSU9jM1dM?=
 =?utf-8?B?bkJIYzhmanoraDJEVzhGSnM5K3lBPT0=?=
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f000c3-881e-4bd5-093f-08d9c3b5232b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 12:35:00.1155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZN5m1lHOv2HLdyHjQOVcze0hapA1HBJ6B6X9gEM9OPprIK4YKSTKf5EqirwxKiUJqbaWwCVtftV9sNKPpI/uWSJzBeAgwFEFN6asLgztuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR07MB7485
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi!

On 20/12/2021 12:28, Tudor.Ambarus@microchip.com wrote:
>> I however run the above patch because of the reasons described in the commit message.
>> Nevertheless, the bug fixed now remains a bug no matter what triggers it.
> I'm not yet convinced that this is the best way to fix it. Should we update
> the erase mask to cover this case?

Well, let's wait until the maintainers form their opinion. I've listed the functions which
zero the size (spi_nor_parse_4bait() or spi_nor_init_non_uniform_erase_map()), there are
already functions which check for zero:
spi_nor_select_uniform_erase()
spi_nor_select_erase()

-- 
Best regards,
Alexander Sverdlin.
