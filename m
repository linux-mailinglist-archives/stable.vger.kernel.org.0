Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5537494212
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 21:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiASUsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 15:48:06 -0500
Received: from mail-dm6nam08on2042.outbound.protection.outlook.com ([40.107.102.42]:13664
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234528AbiASUsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 15:48:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiiLcUkBXZfZo9SI2Nn30MGfuAtw9Uk4q5hvQMfu3PvZre0rFsmTliVQsd6wcCoHZSTz6g/lgzpriNdhAUCRGzdA9k/wocsvSz9m+KQ33dqOQoy2s0z7MKCwoZ4bZVf4A9VwqzOCGQvspgt6KZGORaNbdJrkkyx88GbrxG7IADZq5SP/NFktfOQhsT3od6OEUtlDaeu1RpUHl/kiw/jGjH4MDZKFDeSbauNHllU8W/q7NjMznhIffoPnF2IOBQrkExxEIX/HZKKQs3qY27FRaw+lGibfZOMdjWCi1+1WJICrAz+02NB9Ryempr3BAjKYDHqgGR06iPo5srZofwrU/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qf+0hHQGNl99NT4rmAZZh0ntXMtHCS+FqKyJsQxxx4k=;
 b=kh7ohrLBLWGuUIa+dyIjP1tbXcEXBSPrPPh1h0L/Dbu1jTXfV3SwZSIs+2KuVtwlWGZLdsEw33k7HGgKVpBateeMNip+kmrxJ3V1f5SJ1rL1YIrH+tbrJgUNm2nas9zJ2eDpTHJlwoPqIC8Fy7s9MsY4BMwZIrhCPh6tLH22w5Rs7NbIlKtP40NR/40s3Qr9/Rj1NeZi2+2aO//uF8dmf3EXwGIvdU586yIEliS/Biqi4LwYMjxHVceWvdFzTi04vGVYJOuTzu5RS8zxQd5A4kc2asZnVxR5Py/Il68K60y8lb/qAQUwQyTxcNumCCd8pUBopcKECeCiT73CJCKpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=vpitech.onmicrosoft.com; s=selector2-vpitech-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qf+0hHQGNl99NT4rmAZZh0ntXMtHCS+FqKyJsQxxx4k=;
 b=CZ/HMyPoVPnvXoI2N0K8Tk+3OZTXhGmG/Bvw1OwcHaD5g2jNnmE+Pcl7FtaVxdtl6e7rGIY2PMrtScv8oz+HA0GXyEhc6TrliFu6PpB/pdcy31CbTvozoiygcfWOeVLhzBCJUB648lPGe61G/d6GPcU3E3pXUzgosxhxPBAmvac=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vpitech.com;
Received: from CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:15b::19)
 by CO1P222MB0193.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:158::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Wed, 19 Jan
 2022 20:48:03 +0000
Received: from CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM
 ([fe80::acb2:d13e:3a3:c824]) by CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM
 ([fe80::acb2:d13e:3a3:c824%9]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 20:48:03 +0000
Date:   Wed, 19 Jan 2022 13:48:01 -0700
From:   Alex Henrie <alexh@vpitech.com>
To:     linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Hector Martin <marcan@marcan.st>, Jean Delvare <jdelvare@suse.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH v3] i2c: i801: Safely share SMBus with BIOS/ACPI
Message-Id: <20220119134801.c9bfa050d8374b37b33c06d1@vpitech.com>
In-Reply-To: <20210626054113.246309-1-marcan@marcan.st>
References: <20210626054113.246309-1-marcan@marcan.st>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-unknown-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR20CA0012.namprd20.prod.outlook.com
 (2603:10b6:300:13d::22) To CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:15b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7085f54-8c24-4ad0-cc13-08d9db8cfca2
X-MS-TrafficTypeDiagnostic: CO1P222MB0193:EE_
X-Microsoft-Antispam-PRVS: <CO1P222MB01935A12B88280FE7310E873B8599@CO1P222MB0193.NAMP222.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5lWZDinowPVPYttRwZYNHekeCA4m+D3dSZp/NQuFPHXX5M7iF3+vX2j9T2HQpL/OaaQvJ/e/ueLacXrSM+jukcVmcs2sdZAKwDz7m4B6zhZI5lNXdetZvtgEwNTm95j9U+FAql7E5pStVp1YulsUqZRfrZlxddNjG5sV2bgI86RpeJVv1vJsVFIIdEGRmNVsTXmqPhgckxtpq34HopDPoSAyp7SZ7yltkeIOlGX0CNAv2WUnpPsNYPx/GVdt1Jyv2/MJkTk6zr3ZipbRXKq/T3hj/M0tLfzoluwJJEBNopHu7/4/pQT5sel172Flgq+HjQDb1mDBB93RGKZbLSWkKyKdkGbV8aFdMfrLkLi9knySrfmhdwekZXpUwiZy8JebE39LDqrgMX7bKplFnlpwldcIWq2vYBLH6h1hxstikurSO1K4q+tV0nFlVv2NKC1vQ3xuLihRCBpdBdKqBiwCkfoBvFokkGtH9Q0DeCBRd1LYiLiIU/2nZdgD5MCDD9jCVELjdZC3jouCn06344uVrqdJnW5UFBl+q3i+RYbsmkH8oXkPL6TlPj1tjlfZSzQqjHdRb4UwtoSdToSknFkWx95b6rkdSLGfwvYHp0UkDLXw4NQcqTHe5FvuGdB5SKchzprmZsIb6jO0T0th/VhmHTZn335xEsP3Ig+aQlNAsdYyR4pXPYgwr7SQ6hnHW2sOBVB1r09wgdVR0w8OgQ5cjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(376002)(396003)(366004)(136003)(346002)(6486002)(558084003)(4270600006)(1076003)(36756003)(66476007)(66556008)(316002)(52116002)(186003)(38350700002)(66946007)(26005)(2616005)(8676002)(2906002)(8936002)(6512007)(5660300002)(19618925003)(86362001)(38100700002)(6506007)(508600001)(4326008)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1K4zBVdnVKqsQFHVblBAOfD6JyOM7Nitnyp0aSjjFci3B7+7UZvPtSSVZu3a?=
 =?us-ascii?Q?NzcH7JzJaicU+zqeYm3vzFfX4+mSUoqbCK/VDBenz9PORhz8AL3XmNMwwP1Y?=
 =?us-ascii?Q?JOKcFPLS6o0r5skxTf/lPBPLqlc8e6di6W5Pey1LopNDuiLG3pkGqKMbm02n?=
 =?us-ascii?Q?PSuhxXZCKWb5MjK8L7jZxu4uqXQMu9r1D+lBRxb5BzmGpkmWGFbT2Wp5knFd?=
 =?us-ascii?Q?m8Re7tqxuMVMiFim9udxoiop6jgZY4WFvrxH3unuFG+OH5YrMIvYkxKQL4cF?=
 =?us-ascii?Q?ppEpbID0VZozG5Fr/Lz7Z2jMDmN4wAA/8m1CpWS5ofAsgu24IPjnAawpMxDR?=
 =?us-ascii?Q?c8rP6sXpkgMjVZX22BKzn26HI1JFiF0FOeL9GabHP8ij7i1MmiYqI+C4eCIc?=
 =?us-ascii?Q?onUhqz01/qQ/HNUqXcLg9L8m+MbiJTJvGWuDu4Pwkc1oESzih2p5ht8WCJS8?=
 =?us-ascii?Q?+Zi+4MvFkD8bR5nhHocXH+vJbytAzCAZKHKtGe9BIDXPDhiTeiAWrlp5uCxI?=
 =?us-ascii?Q?7yeKAl+XWNtMISoXC+9dzo44ocAcI5AChDz+kf0yftPFrDXuHnFTvhG0yr/5?=
 =?us-ascii?Q?DjMZe3U+lk0F/E2yVGSxFO8ihLqlZ51ydSoUIm7aSPSHI2CXj1GMRuo4cxlF?=
 =?us-ascii?Q?tPmD7CQq4uQmYxiPiVapPdPwHrpOwr28ZmDMt7LWRi5VD3CVbW7UR4o9sXwy?=
 =?us-ascii?Q?c9Wt7IFHHF4E2dPXn2B/JNDI9uHwxoG0MV+6DH2YuLkmysNrk23bzn/ETQKC?=
 =?us-ascii?Q?ryfjXE/tIeMRkR6no7g/pFl2Hh8xE2IAzzoZksBWcm3JGFXzGL5MNCpfZ8Jp?=
 =?us-ascii?Q?9Ya2D46iMJtXIeCLi4AcSQkp8FMjRmJtS0coRsPLum794yM3y8hUTZpo6uHd?=
 =?us-ascii?Q?gO3nAZHEq9U0KZKHcgFcQywteIGCmroBVuOwVRcMIyEmdPAEr1OPIS/OKw0z?=
 =?us-ascii?Q?eeAhW+irdJC8R2XPdoIvHpzsHYuzZnULrO9WA/Ly30fzg9YKb2RYZWy2HmjH?=
 =?us-ascii?Q?u6gPCzYc6wyS94KcBqQSXI1+8POXsBvnj0XBlUHXXxwJNYTdmJCpAuz/SoDV?=
 =?us-ascii?Q?DiY7E6cWDT+rHOu8ua1FmIIoE3I32SrAcq9MO4c6ABBF+XlPbNpaSsvLPSaD?=
 =?us-ascii?Q?Wx7yZyG5u3O95JNZwQASfXk+zDOAIZPkk7VFElGOVK4mBlFSiwbFW6T42ufV?=
 =?us-ascii?Q?T5dFd41iVKyuZjR+MdX9NAI0eqwXKRpHlGl3nPGbF+5vVUk42aV3jYHW+BXA?=
 =?us-ascii?Q?aEpbG5Q1C2j85vTqDnBD7hUgpUj1ZP/2xI0XK+DMQmBo/WJSEQRb/D5R7711?=
 =?us-ascii?Q?uVPfbhNm3/c0OV4c7nCFIeq7W0spvE75mR1tzz5oGfwKQXM4q2jyYw1cpKHV?=
 =?us-ascii?Q?KCUjwF2lOL71QlVmf6iI9FGezdg3vdqJJ0jJeKKXN+K/XXx6/xkLNHMHjTdE?=
 =?us-ascii?Q?hthFizAZQx6UItab3GHi36RCjfLVe6vzYGjBXeh8nBfg6O5WItNsMQCZr4jj?=
 =?us-ascii?Q?UyVHaIXZxdmacP1GqijFDqSKTdohoAe7RjqcWltiPXDPiO9pilLEQ7jJRfrG?=
 =?us-ascii?Q?afmFcJNfjCnvECDn1HHTJRuwHL1SAyc0HzQyN545PJDgpKHV9gtyUZix4ZC3?=
 =?us-ascii?Q?klVrHnGuKx3EF8MpP0wM2t0=3D?=
X-OriginatorOrg: vpitech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7085f54-8c24-4ad0-cc13-08d9db8cfca2
X-MS-Exchange-CrossTenant-AuthSource: CO1P222MB0212.NAMP222.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 20:48:03.2579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 130d6264-38b7-4474-a9bf-511ff1224fac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kwPBx50TUVZpkqnPT2JYu2a82hI2aXQvxi3oVaIoHFzy8znW/kNcLV4LLwn3BqkFbQmd1WNvv+UxaUXqkT4Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1P222MB0193
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-by: Alex Henrie <alexh@vpitech.com>
